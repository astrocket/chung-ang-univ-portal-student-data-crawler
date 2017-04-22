class ParsersController < ParsingController

  def index
    unless current_user.has_role? :admin
      if current_user.student != 'n/a'
        redirect_to "/parsers?student=#{current_user.student}"
      end
    end
  end

  def show
    checked_by_admin #관리자 승인 여부 체크

    student_id = params[:student]

    unless current_user.has_role? :admin
      if User.with_role(:admin).where('student = ?', params[:student]).exists?
        flash[:toast] = '어딜감히 !'
        redirect_to '/' and return
      end
    end

    #슈퍼유저의 검색어를 모두 통과
    if current_user.has_role? :admin
      student = student_id
    elsif current_user.student != 'n/a' and current_user.gender != 'n/a'
      student = current_user.student
    else
      student_data = xml_map_chunk_extraction_job(
          map_chunk = get_user_data(params[:student]), #개인정보 가져오기
          key_array = %w(kornm regno chanm engnm gen sustnm mjnm probshyr advyear advshtm stdno campcd ),
          #0한국이름 1주민 2한자명 3영문명 4성별 5소속단과대 6전공 7현재학년 8최근등록년도 9최근등록학기 10학번 11캠퍼스
          filter_array = %w(msgCode),
          false #하나의 어레이만 필요한거는 false로 해놓고 쌓아놓는다
      )
      #가입한 계정이 본인의 계정인지 조회한 학번에서 얻은 이름과 가입시 입력한 이름을 확인
      if current_user.name != student_data[0]
        flash[:toast] = '내 이름과 일치하는 학번이 아닙니다. 이름이 본인명이 아니라면 이름을 변경하세요'
        redirect_to edit_user_registration_path and return
      end
      #가입한 계정에 학번이 있을 경우에 그 학번의 조회를 승인하고 자기것이 아닌 학번은 조회를 불허가한다.
      if current_user.student.present?
        if current_user.student == student_id
          student = current_user.student
        else
          flash[:toast] = '내 학번이 아닙니다'
          redirect_to '/' and return
        end
      else
        current_user.update(
            {
                :student => student_id,
                :birth => student_data[1],
                :english_name => student_data[3],
                :chinese_name => student_data[2],
                :gender => student_data[4],
                :department_name => student_data[5],
                :major_name => student_data[6],
                :recent_grade => student_data[7],
                :recent_year => student_data[8],
                :recent_semester => student_data[9],
                :campus => student_data[11]
            }
        )
        current_user.save
        student = current_user.student
      end
    end

    #올해 이번학기 수업을 유저가 가지고 있으면 데이터베이스에서 리턴하고 아니면 새로 검색해서 새로운 수업 모델 객체을 만들어낸다.
    have_already = current_user.courses.where('year = ? AND semester = ?', Time.now.year.to_s, find_semester)

    if have_already.present?
      @course_list = have_already
    elsif current_user.has_role? :admin and User.find_by(:student => student).present?
      @target_user = User.find_by(:student => student)
      @course_list = @target_user.courses.where('year = ? AND semester = ?', Time.now.year.to_s, find_semester)
    else
      if current_user.has_role? :admin
        @course_list = find_and_create_courses_of(student)
      else
        @course_list = find_and_create_courses_of(student).where('year = ? AND semester = ?', Time.now.year.to_s, find_semester)
      end
    end

=begin
    <sbjtno value='18685' />
    <clssno value='01' />
    <campcd value='1' />
    <sust value='3B410' />
    <pobtcd value='62' />
    <kornm value='전자기학' />
    <pnt value='3' />
    <themtm value='3' />
    <profnm value='정태경' />
    <clsefg value='N' />
    <lttm value='3' />
    <ltbdrm value='월2, 수1,2&lt;br&gt;310관(310관) 616호 &lt;강의실&gt;' />
    <repobtfg value='Y' />
    <corscd value='0' />
    <pobtyy value='2015' /> 재수강 년도
    <pobtshtmnm value='1' /> 재수강 학기
    <pobtsbjtno value='18685' /> 재수강 렉쳐코드
    <pobtnm value='복전' />
    <status value='N' />
    <delfg value='삭제' />
    <stdno value='20112020' />
    <year value='2017' />
    <shtm value='1' />
    <pobtorg value='62' />
    <pobtgb value='all' />
    <fileusefg value='N' />
=end

    @all_course_notice_list = xml_map_chunk_extraction_job(
        map_chunk = get_all_course_notice_list(student, 100), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username lecturenameboardtitle lectureno boardno boarddate boardcheck boardhit), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
        filter_array = %w(msgCode),
        true
    )

    if current_user.has_role? :admin
      #관리자 계정용 정보 !!!!!!! Pundit 으로 반드시 권한 확인 후 코드 실행시켜야 속도 문제 줄어듦
      @student_data = xml_map_chunk_extraction_job(
          map_chunk = get_user_data(params[:student]), #개인정보 가져오기
          key_array = %w(kornm regno chanm engnm gen sustnm mjnm probshyr advyear advshtm stdno campcd ),
          #0한국이름 1주민 2한자명 3영문명 4성별 5소속단과대 6전공 7현재학년 8최근등록년도 9최근등록학기 10학번 11캠퍼스
          filter_array = %w(msgCode),
          false #하나의 어레이만 필요한거는 false로 해놓고 쌓아놓는다
      )
      @response = super_user_data(student)
      @professor_data = super_user_prof_data(student)
    end
  end

  private

  def find_and_create_courses_of(student)
    course_list = []

    #이번학기 수업리스트를 웹에서 긁어낸다(학기가 바뀔때마다 데이터가 자동으로 수집됨)
    course_list_array = xml_map_chunk_extraction_job(
        map_chunk = get_course_list(student, Time.now.year, find_semester).split("<vector id='resList'>")[1], #수강 과목 리스트 가져오기 이거 년도/학기 별로 가져올 수 있게 코드 수정 필요
        #폐강여부  렉쳐넘버 렉쳐분반   캠퍼스  과목명 학점  교수명   장소    년도  학기
        key_array = %w( clsefg sbjtno clssno campcd kornm pnt profnm ltbdrm year shtm pobtnm ),
        filter_array = %w(msgCode),
        true
    )
    course_list_array.each do |course|
      unless course[0] == 'Y'
        course_number = get_course_id(student, course[4].split('(')[0], course[6])
        #이미 생성 된 수업인지 확인한다. 생성된 수업이면 if 문 안거치고 바로 사용자에게 넣어준다.
        target_course = Course.where('number = ?', course_number).take
        #처음보는 수업이면 수업을 생성하고 해당 수업에 배정시킬 교수로직으로 넘긴다
        if target_course.nil?
          target_course = Course.create(
              {
                  :name => course[4],
                  :number => course_number, #포탈에서 날라오는 lecture를 내가 죄다 course 라고 적고 코딩했음. 조심하자. xml 속 실제 데이터에서 가장 중요한건 lectureno 값인데 이걸 course_number 에 저장했음
                  :location => course[7],
                  :major => course[10],
                  :lecture_number => course[1],
                  :lecture_seperation => course[2],
                  #:study_date => ,
                  :year => course[8],
                  :semester => course[9],
                  :point => course[5],
                  #:department => ,
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

    find_and_create_past_courses_of(student, 2017, Time.now.year)

    if current_user.has_role? :admin
      course_list
    else
      current_user.courses
    end
  end

  def find_and_create_past_courses_of(student, start_year, end_year)
    (start_year..end_year).each do |year|
      (1..4).each do |semester|
        chunk = xml_map_chunk_extraction_job(
            map_chunk = get_course_time_machine(student, year, semester),
            key_array = %w(lectureno lecturenum lecturenamenum profname studydate subjectname),
            filter_array = %w(msgCode),
            true
        )

        if chunk.present?
          chunk.each do |course|
            target_course = Course.where('number = ?', course[0]).take
            if target_course.nil?
              target_course = Course.create(
                  {
                      :name => course[2],
                      :number => course[0], #포탈에서 날라오는 lecture를 내가 죄다 course 라고 적고 코딩했음. 조심하자. xml 속 실제 데이터에서 가장 중요한건 lectureno 값인데 이걸 course_number 에 저장했음
                      #:location => course[7],
                      #:major => course[4],
                      #:lecture_number => course[1],
                      #:lecture_seperation => course[2],
                      :study_date => course[4],
                      :year => year.to_s,
                      :semester => semester.to_s,
                      #:point => course[5],
                      :department => course[5],
                      :professor_name => course[3]
                  }
              )
              unless target_course.professor_name.nil?
                find_and_add_professor_of_course(target_course, student, target_course.number)
              end
              unless current_user.has_role? :admin
                current_user.courses << target_course
              end
            else
              #찾은 수강정보가 있긴한데 아직 기간정보가 입력되지 않은 자료, 즉 현재학기의 정보를 긁어서 만든 과목일 경우에 추가 정보를 업데이트 시켜주는 로직
              #교수값은 이미 있으므로 다시 알아볼 필요 없음
              if target_course.number == course[0] and target_course.study_date == 'n/a'
                target_course.update_attributes(
                    {
                        #:name => course[1],
                        #:number => course[0], #포탈에서 날라오는 lecture를 내가 죄다 course 라고 적고 코딩했음. 조심하자. xml 속 실제 데이터에서 가장 중요한건 lectureno 값인데 이걸 course_number 에 저장했음
                        #:location => course[7],
                        #:major => ,
                        #:lecture_number => course[1],
                        #:lecture_seperation => course[2],
                        :study_date => course[4],
                        :year => year.to_s,
                        :semester => semester.to_s,
                        #:point => course[5],
                        :department => course[5],
                        :professor_name => course[3]
                    }
                )
              elsif target_course.number != course[0]
                Mistake.create(:content => "#{Time.now} : 데이터베이스에서 꺼낸 수강 정보와 #{student}를 통해 호출한 과거 기록이 일치하지 않음. 찾은기록 : #{target_course.number}, 불러온기록 : #{course[0]}")
              end
            end
          end
        end
      end
    end
  end

  def find_and_add_professor_of_course(target_course, student, course_number)
    professor = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_professor(student, course_number), #교수정보 가져오기 교수id = 10번
        key_array = %w(username email usertel userhp groupname collegename subjectname career homeurl userimg userid),
        filter_array = %w(msgCode),
        true
    )[0] #여기서 교수 청크의 배열은 오직 1개만 리턴되므로 첫번째 값만 받아오면 됨
    #이미 생성된 교수인지 확인한다.
    target_professor = Professor.where('number = ?', professor[10]).take
    #처음보는 교수면 일단 교수하나를 만들고 기존의 교수라면 그 교수를 바로 그 교과목에 넣어준다.
    if target_professor.nil?
      target_course.professors << Professor.create(
          {
              :number => professor[10],
              :name => professor[0],
              :email => professor[1],
              :tel => professor[2],
              :phone => professor[3],
              :group => professor[4],
              :college => professor[5],
              :subject => professor[6],
              :career => professor[7],
              :site => professor[8],
              :image => professor[9]
          }
      )
      find_and_add_sub_professor_of_course(target_course, student, course_number)
    else
      target_course.professors << target_professor
    end
  end

  def find_and_add_sub_professor_of_course(target_course, student, course_number)
    #교수가 한명보다 많으면 두번째 교수를 검색한다.
    if target_course.professor_name.split(',').length == 2
      sub_professor = xml_map_chunk_extraction_job(
          map_chunk = get_eclass_sub_professor(student, course_number), #교수정보 가져오기 교수id = 10번
          key_array = %w(username email usertel userhp groupname collegename subjectname career homeurl userimg userid),
          filter_array = %w(msgCode),
          true
      )[0]
      #두번째 교수가 이미 생성된 교수인지 확인한다.
      target_sub_professor = Professor.where('number = ?', sub_professor[10]).take
      #처음보는 교수면 교수를 하나 만들고 기존의 교수라면 그 교수를 바로 그 교과목에 넣어준다.
      if target_sub_professor.nil?
        target_course.professors << Professor.create(
            {
                :number => sub_professor[10],
                :name => sub_professor[0],
                :email => sub_professor[1],
                :tel => sub_professor[2],
                :phone => sub_professor[3],
                :group => sub_professor[4],
                :college => sub_professor[5],
                :subject => sub_professor[6],
                :career => sub_professor[7],
                :site => sub_professor[8],
                :image => sub_professor[9]
            }
        )
      end
    end
  end

end
