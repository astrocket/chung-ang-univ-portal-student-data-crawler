class ParsersController < ParsingController
  before_action :status_check, only: [:show]

  def index
    unless current_user.has_role? :admin
      unless current_user.student.nil?
        redirect_to "/parsers?student=#{current_user.student}"
      end
    end
  end

  def show
    @test = get_user_data(params[:student])
    if params[:student].nil?
      redirect_to root_path, notice: '계정에 학번값이 입력되지 않았습니다' and return
    end
    start_year = 2017
    #슈퍼유저 // 일반유저
    if current_user.has_role?(:admin) #슈퍼유저
      student = params[:student]

      sud = super_user_prof_data(student)
      @super_info = sud[0]
      @super_grade = sud[1]
      #@sud_checker = super_user_prof_all_data(student)

      @target_user = User.find_by(:student => student) #찾는유저가 가입된 유저인지 검색

      if @target_user.present? #유저가 가입 되어있고 학점이 긁혔으면 데이터에서 올해듣는 과목을 가져온다.
        if @target_user.gpa == 'n/a' or !@target_user.phone.present? or (@target_user.recent_year < Time.now.year.to_s and @target_user.recent_semester < find_semester) #해가 넘어가고 학기가 지나야 검색 비밀 정보가 업데이트 된다.
          @target_user.update(
              {
                  :final_gpa => @super_grade[0][5].to_f, :gpa => @super_grade[0].reverse.map { |a| a + '/' unless a.nil? }.join,
                  :admission_type => @super_info[1], :tel => @super_info[2],
                  :phone => @super_info[3], :military => @super_info[0], :mail => @super_info[5],
                  :address => @super_info[4], :preschool_type => @super_info[11], :preschool_name => @super_info[12],
                  :parent_name => @super_info[6], :parent_type => @super_info[7], :parent_tel => @super_info[8],
                  :parent_phone => @super_info[9], :parent_address => @super_info[10]
              }
          ) #0군필여부	1입학 2집전화   3폰	   4주소   5메일  6부모명   7부모구분 8부모집전화 9부모폰 10부모주소 11직전학교종류 12학교명
          unless @target_user.save
            msg = "#{@target_user.student} : (#{@target_user.errors.messages.map { |k, v| v }})"
          end
        end
        @course_list = @target_user.courses.where('year = ? AND semester = ?', Time.now.year.to_s, find_semester)
      else #유저정보가 없으면 HTTP 로 검색해서 가져오고, 학기의 과목 또한 함께 가져온다.
        ssd = extract_user_data(student)
        #검색된 학생의 임시 객체 생성
        @target_user = User.new(
            {
                :name => ssd[0], :student => student, :birth => ssd[1], :english_name => ssd[3],
                :chinese_name => ssd[2], :gender => ssd[4], :department_name => ssd[5], :major_name => ssd[6],
                :recent_grade => ssd[7], :recent_year => ssd[8], :recent_semester => ssd[9], :campus => ssd[11],
                :college_name => ssd[12], :college_code => ssd[13], :department_code => ssd[14], :major_code => ssd[15],
                :final_gpa => @super_grade[0][5].to_f, :gpa => @super_grade[0].reverse.map { |a| a + '/' unless a.nil? }.join,
                :admission_type => @super_info[1], :tel => @super_info[2],
                :phone => @super_info[3], :military => @super_info[0], :mail => @super_info[5],
                :address => @super_info[4], :preschool_type => @super_info[11], :preschool_name => @super_info[12],
                :parent_name => @super_info[6], :parent_type => @super_info[7], :parent_tel => @super_info[8],
                :parent_phone => @super_info[9], :parent_address => @super_info[10]
            }
        )
        @course_list = find_and_create_courses_of(student, start_year)
      end

    else #일반유저
      #일반유저가 슈퍼유저를 조회하면 경고날리기
      if User.with_role(:admin).where('student = ?', params[:student]).exists?
        redirect_to '/', notice: '누구를 조회하려고 !' and return
      end

      #일반유저에게 학번이 이미 부여되었고, 24시간 이전에 활동했던 내역이 있을 경우 검색없이 자기 학번 활용
      key_time = 24.hours #데이터 다시 긁는데 필요한 기준 시간

      #유저학번확인, 추가정보업데이트 // 학번미등록시정보등록
      if current_user.student.present? #유저학번확인
        student = current_user.student
        if Time.now - current_user.last_sign_in_at < key_time
          @target_user = current_user
        else #추가정보업데이트
          sdu = extract_user_data(current_user.student)
          current_user.update(
              {
                  :birth => sdu[1], :english_name => sdu[3], :chinese_name => sdu[2], :gender => sdu[4],
                  :department_name => sdu[5], :major_name => sdu[6], :recent_grade => sdu[7], :recent_year => sdu[8],
                  :recent_semester => sdu[9], :campus => sdu[11], :college_name => sdu[12], :college_code => sdu[13],
                  :department_code => sdu[14], :major_code => sdu[15]
              }
          )
          if current_user.save
            @target_user = current_user
          else
            msg = "#{current_user.student} 업데이트 실패"
          end
        end
      else #학번미등록시정보등록
        sd = extract_user_data(params[:student])
        if current_user.name != sd[0]
          redirect_to edit_user_registration_path, notice: '내 이름과 일치하는 학번이 아닙니다. 이름이 본인명이 아니라면 이름을 변경하세요' and return
        else
          current_user.update(
              {
                  :student => params[:student], :birth => sd[1], :english_name => sd[3], :chinese_name => sd[2],
                  :gender => sd[4], :department_name => sd[5], :major_name => sd[6], :recent_grade => sd[7],
                  :recent_year => sd[8], :recent_semester => sd[9], :campus => sd[11], :college_name => sd[12],
                  :college_code => sd[13], :department_code => sd[14], :major_code => sd[15]
              }
          )
          if current_user.save
            @target_user = current_user
            student = current_user.student
          else
            msg = "#{current_user.student} : (#{current_user.errors.messages.map { |k, v| v }})"
          end
        end
      end

      #수업찾기 (올해의 해당학기 수업을 갖고 있는지 확인)
      have_already = current_user.courses.where('year = ? AND semester = ?', Time.now.year.to_s, find_semester)
      if have_already.present?
        @course_list = have_already
      else
        @course_list = find_and_create_courses_of(student, start_year).where('year = ? AND semester = ?', Time.now.year.to_s, find_semester)
      end

    end

    if msg.present?
      m = Mistake.create(:content => msg)
      redirect_to messages_path, notice: "에러코드 : '#{m.id}' #{msg}" and return
    end

    #항상 실시간으로 불러야하는 부분
    @all_course_notice_list = extract_course_notice_list(student, 100)

  end

  private

  def status_check
    if current_user.sign_in_count > 2 and !current_user.status and !current_user.has_role?(:admin)
      redirect_to messages_path, notice: '두번째 로그인 부터는 관리자의 승인을 받아야 사용가능합니다.'
    end
  end

  def find_and_create_courses_of(student, start_year)
    course_list = []

    #이번학기 수업리스트를 웹에서 긁어낸다(학기가 바뀔때마다 데이터가 자동으로 수집됨)
    course_list_array = extract_course_list(student)
    course_list_array.each do |course|
      unless course[0] == 'Y'
        course_number = get_course_id(student, course[4].split('(')[0], course[6])
        #이미 생성 된 수업인지 확인한다. 생성된 수업이면 if 문 안거치고 바로 사용자에게 넣어준다.
        target_course = Course.where('number = ?', course_number).take
        #처음보는 수업이면 수업을 생성하고 해당 수업에 배정시킬 교수로직으로 넘긴다
        if target_course.nil?
          target_course = Course.create(
              {
                  :name => course[4], :number => course_number, #포탈에서 날라오는 lecture를 내가 죄다 course 라고 적고 코딩했음. 조심하자. xml 속 실제 데이터에서 가장 중요한건 lectureno 값인데 이걸 course_number 에 저장했음
                  :location => course[7], :major => course[10],
                  :lecture_number => course[1], :lecture_seperation => course[2],
                  #:study_date => , :year => course[8],
                  :semester => course[9], :point => course[5], #:department => ,
                  :professor_name => course[6]
              }
          )

          unless target_course.professor_name.nil?
            find_and_add_professor_of_course(target_course, student, course_number)
          end
        end
        if current_user.has_role? :admin
          course_list << target_course
        else
          current_user.courses << target_course
        end
      end
    end

    find_and_create_past_courses_of(student, start_year, Time.now.year)

    if current_user.has_role? :admin
      course_list
    else
      current_user.courses
    end
  end

  def find_and_create_past_courses_of(student, start_year, end_year)
    (start_year..end_year).each do |year|
      (1..4).each do |semester|
        chunk = extract_course_time_machine(student, year, semester)
        if chunk.present?
          chunk.each do |course|
            target_course = Course.where('number = ?', course[0]).take
            if target_course.nil?
              target_course = Course.create(
                  {
                      :name => course[2], :number => course[0], #포탈에서 날라오는 lecture를 내가 죄다 course 라고 적고 코딩했음. 조심하자. xml 속 실제 데이터에서 가장 중요한건 lectureno 값인데 이걸 course_number 에 저장했음
                      #:location => course[7], :major => course[4],
                      #:lecture_number => course[1], :lecture_seperation => course[2],
                      :study_date => course[4], :year => year.to_s,
                      :semester => semester.to_s, #:point => course[5],
                      :department => course[5], :professor_name => course[3]
                  }
              )
              unless target_course.professor_name.nil?
                find_and_add_professor_of_course(target_course, student, target_course.number)
              end
              unless current_user.has_role? :admin
                current_user.courses << target_course
              end
            elsif current_user.courses.include?(target_course) #존재하는 수강정보인데 나한테 있으면 업데이트만 해주고 저장하지 않는다.
              #찾은 수강정보가 있긴한데 아직 기간정보가 입력되지 않은 자료, 즉 현재학기의 정보를 긁어서 만든 과목일 경우에 추가 정보를 업데이트 시켜주는 로직
              #교수값은 이미 있으므로 다시 알아볼 필요 없음
              if target_course.number == course[0] and target_course.study_date == 'n/a'
                target_course.update_attributes(
                    {
                        #:name => course[1], :number => course[0], #포탈에서 날라오는 lecture를 내가 죄다 course 라고 적고 코딩했음. 조심하자. xml 속 실제 데이터에서 가장 중요한건 lectureno 값인데 이걸 course_number 에 저장했음
                        #:location => course[7], :major => ,
                        #:lecture_number => course[1], :lecture_seperation => course[2],
                        :study_date => course[4], :year => year.to_s,
                        :semester => semester.to_s, #:point => course[5],
                        :department => course[5], :professor_name => course[3]
                    }
                )
              elsif target_course.number != course[0]
                Mistake.create(:content => "#{Time.now} : 데이터베이스에서 꺼낸 수강 정보와 #{student}를 통해 호출한 과거 기록이 일치하지 않음. 찾은기록 : #{target_course.number}, 불러온기록 : #{course[0]}")
              end
            else #존재하는 수강정보인데 나한테 없으면 추가로 저장해준다.
              unless current_user.has_role? :admin
                current_user.courses << target_course
              end
            end
            unless target_course.department == 'n/a'
              find_and_create_hakboo_of_target(target_course, target_course.department)
            end
          end
        end
      end
    end
  end

  def find_and_add_professor_of_course(target_course, student, course_number)
    pfs = extract_eclass_professor(student, course_number) #여기서 교수 청크의 배열은 오직 1개만 리턴되므로 첫번째 값만 받아오면 됨
    pf = pfs[0]
    #이미 생성된 교수인지 확인한다.
    target_professor = Professor.where('number = ?', pf[10]).take
    #처음보는 교수면 일단 교수하나를 만들고 기존의 교수라면 그 교수를 바로 그 교과목에 넣어준다.
    if target_professor.nil?
      target_professor = Professor.create(
          {
              :number => pf[10], :name => pf[0], :email => pf[1], :tel => pf[2],
              :phone => pf[3], :group => pf[4], :college => pf[5], :subject => pf[6],
              :career => pf[7], :site => pf[8], :image => pf[9]
          }
      )
    end
    target_course.professors << target_professor

    unless target_professor.subject == 'n/a'
      find_and_create_hakboo_of_target(target_professor, target_professor.subject)
    end

    if pfs[2].present? #두번째 교수가 있으면 리턴된 청크에서 [2]에 값이 리턴된다. (교수이름[0] 교수번호[10])
      find_and_add_sub_professor_of_course(target_course, pfs[2][10], course_number)
    end
  end

  def find_and_add_sub_professor_of_course(target_course, professor, course_number)
    #교수가 한명보다 많으면 두번째 교수를 검색한다.
    if target_course.professor_name.split(',').length == 2
      spf = extract_eclass_sub_professor(professor, course_number)[0]
      #두번째 교수가 이미 생성된 교수인지 확인한다.
      target_sub_professor = Professor.where('number = ?', spf[10]).take
      #처음보는 교수면 교수를 하나 만들고 기존의 교수라면 그 교수를 바로 그 교과목에 넣어준다.
      if target_sub_professor.nil?
        target_sub_professor = Professor.create(
            {
                :number => spf[10], :name => spf[0], :email => spf[1], :tel => spf[2],
                :phone => spf[3], :group => spf[4], :college => spf[5], :subject => spf[6],
                :career => spf[7], :site => spf[8], :image => spf[9]
            }
        )
      end
      target_course.professors << target_sub_professor

      unless target_sub_professor.subject == 'n/a' or current_user.has_role?(:admin)
        find_and_create_hakboo_of_target(target_sub_professor, target_sub_professor.subject)
      end
    end
  end

  def find_and_create_hakboo_of_target(target, hakboo)
    if hakboo.nil? or hakboo == '대학전체'
      td = Hakboo.find(1) #학정보가 없으면 기타로 취급
    else
      td = Hakboo.where('name = ?', hakboo).take
      if td.nil?
        td = Hakboo.create(
            {
                :name => hakboo
            }
        )
      end
    end

    unless td.users.include?(current_user)
      td.users << current_user
    end
    unless target.hakboos.include?(td)
      target.hakboos << td
    end
  end

end
