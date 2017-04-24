def show

  student_id = params[:student]

  unless current_user.has_role? :admin
    if User.with_role(:admin).where('student = ?', params[:student]).exists?
      flash[:toast] = '누구를 조회하려고 !'
      redirect_to '/' and return
    end
  end

  #슈퍼유저의 검색어를 모두 통과
  if current_user.has_role? :admin
    student = student_id
    #이미 학번이 있고, 24시간전에 로그인한적이 있다면 검색없이 그냥 자기학번으로 바로 조회
  elsif current_user.student.present? and Time.now - current_user.last_sign_in_at < 24.hours
    if current_user.student == student_id
      student = current_user.student
    else
      flash[:toast] = '내 학번이 아닙니다'
      redirect_to '/' and return
    end
  else
    #신규로 가입한 사람이 정보를 조회하거나, 정상회원이 24시간이 지나서 로그인 한 경우
    sd = xml_map_chunk_extraction_job(
        map_chunk = get_user_data(params[:student]), #개인정보 가져오기
        key_array = %w(kornm regno chanm engnm gen sustnm mjnm probshyr advyear advshtm stdno campcd colgnm colg sust mj ),
        #0한국이름 1주민 2한자명 3영문명 4성별 5소속단과대 6전공 7현재학년 8최근등록년도 9최근등록학기 10학번 11캠퍼스 12소속대학 13대학코드 14학부코드 15전공코드
        filter_array = %w(msgCode),
        false #하나의 어레이만 필요한거는 false로 해놓고 쌓아놓는다
    )
    #가입한 계정이 본인의 계정인지 조회한 학번에서 얻은 이름과 가입시 입력한 이름을 확인하되 신규 가입자만 확인하고 이미 가입해서 인증이 된 사람은 계정업데이트로 넘겨버린다.
    if current_user.name != sd[0] and current_user.gender == 'n/a'
      flash[:toast] = '내 이름과 일치하는 학번이 아닙니다. 이름이 본인명이 아니라면 이름을 변경하세요'
      redirect_to edit_user_registration_path and return
    else
      current_user.update(
          {
              :student => student_id, :birth => sd[1],
              :english_name => sd[3], :chinese_name => sd[2],
              :gender => sd[4], :department_name => sd[5],
              :major_name => sd[6], :recent_grade => sd[7],
              :recent_year => sd[8], :recent_semester => sd[9],
              :campus => sd[11], :college_name => sd[12],
              :college_code => sd[13], :department_code => sd[14],
              :major_code => sd[15]
          }
      )
      current_user.save
    end
    #가입한 계정에 학번이 있을 경우에 그 학번의 조회를 승인하고 조회한 학번이 자기것이 아닌 학번은 조회를 불허가한다.
    if current_user.student.present?
      if current_user.student == student_id
        student = current_user.student
      else
        flash[:toast] = '내 학번이 아닙니다'
        redirect_to '/' and return
      end
      #사실상 가입이 승인되어서 정보가 입력된 유저가 여기에 걸려들 일은 없다
    else
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
      @course_list = find_and_create_courses_of(student) #함수가 알아서 이번 학기것만 담아옴
    else
      @course_list = find_and_create_courses_of(student).where('year = ? AND semester = ?', Time.now.year.to_s, find_semester) #과거 학기까지 조회하고 유저에게 실제로 담긴 데이터 전체가 오므로 올해것만 골라서 뷰로 보내야함
    end
  end

  #항상 실시간으로 불러야하는 부분
  @all_course_notice_list = xml_map_chunk_extraction_job(
      map_chunk = get_all_course_notice_list(student, 100), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
      key_array = %w(username lecturenameboardtitle lectureno boardno boarddate boardcheck boardhit), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
      filter_array = %w(msgCode),
      true
  )

  if current_user.has_role? :admin
    #관리자 계정용 정보 !!!!!!! Pundit 으로 반드시 권한 확인 후 코드 실행시켜야 속도 문제 줄어듦
    ssd = xml_map_chunk_extraction_job(
        map_chunk = get_user_data(params[:student]), #개인정보 가져오기
        key_array = %w(kornm regno chanm engnm gen sustnm mjnm probshyr advyear advshtm stdno campcd ),
        #0한국이름 1주민 2한자명 3영문명 4성별 5소속단과대 6전공 7현재학년 8최근등록년도 9최근등록학기 10학번 11캠퍼스
        filter_array = %w(msgCode),
        false #하나의 어레이만 필요한거는 false로 해놓고 쌓아놓는다
    )
    #검색된 학생의 임시 객체 생성
    @target_user = User.new(
        {
            :name => ssd[0], :student => params[:student],
            :birth => ssd[1], :english_name => ssd[3],
            :chinese_name => ssd[2], :gender => ssd[4],
            :department_name => ssd[5], :major_name => ssd[6],
            :recent_grade => ssd[7], :recent_year => ssd[8],
            :recent_semester => ssd[9], :campus => ssd[11],
            :college_name => ssd[12], :college_code => ssd[13],
            :department_code => ssd[14], :major_code => ssd[15]
        }
    )
    @response = super_user_data(student)
    @professor_data = super_user_prof_data(student)
  end
end