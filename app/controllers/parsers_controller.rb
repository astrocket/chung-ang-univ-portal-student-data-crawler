class ParsersController < ParsingController

  def index

  end

  def show
    student_id = params[:student]

    if user_signed_in?
      unless current_user.has_role? :admin
        if current_user.sign_in_count > 2 and current_user.status == false
          flash[:toast] = '두번째 부터는 관리자의 승인을 받아야 사용가능합니다.'
          redirect_to url_for(:controller => :messages, :action => :index)
        end
      end
    end

    if current_user.has_role? :admin
      student = student_id
    else
      if current_user.student.present?
        if current_user.student == student_id
          student = current_user.student
        else
          flash[:toast] = '내 학번이 아닙니다'
          redirect_to '/'
        end
      else
        current_user.student = student_id
        current_user.save
        student = current_user.student
      end
    end

    @student_data = xml_map_chunk_extraction_job(
        map_chunk = get_user_data(student), #개인정보 가져오기
        key_array = %w(kornm regno chanm engnm gen sustnm mjnm probshyr advyear advshtm stdno campcd ),
        #0한국이름 1소속 2한자명 3영문명 4성별 5소속단과대 6전공 7현재학년 8최근등록년도 9최근등록학기 10학번 11캠퍼스
        filter_array = %w(msgCode),
        false #하나의 어레이만 필요한거는 false로 해놓고 쌓아놓는다
    )
    @course_list = get_course_list(student) #수강 과목 리스트 가져오기 이거 년도/학기 별로 가져올 수 있게 코드 수정 필요
    @all_course_notice_list = xml_map_chunk_extraction_job(
        map_chunk = get_all_course_notice_list(student, 100), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username lecturenameboardtitle lectureno boardno boarddate boardcheck boardhit), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
        filter_array = %w(msgCode),
        true
    )

    if current_user.has_role? :admin
      #관리자 계정용 정보 !!!!!!! Pundit 으로 반드시 권한 확인 후 코드 실행시켜야 속도 문제 줄어듦
      @response = super_user_data(student)
      @professor_data = super_user_prof_data(student)
    end

  end

end
