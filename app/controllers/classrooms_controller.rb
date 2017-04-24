class ClassroomsController < ParsingController

  def show

  end

  def eclass
    student = params[:student]
    @student = student
    if params[:lectureno]
      course_number = params[:lectureno]
      @course_name = params[:course_name]
    else
      @course_name = params[:course].split('(')[0] #이부분은 뷰에서 코스 이름을 가져와야함
      professor = params[:professor]
      course_number = get_course_id(student, @course_name, professor) #코스 번호 가져오기
    end

    @test = course_number
    @student_data = get_user_data(student) #개인정보 가져오기
    @eclass_professor = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_professor(student, course_number), #교수정보 가져오기 교수id = 10번
        key_array = %w(username email usertel userhp groupname collegename subjectname career homeurl userimg userid),
        filter_array = %w(msgCode),
        true, true
    )[0] #여기서 교수 청크의 배열은 오직 1개만 리턴되므로 첫번째 값만 받아오면 됨
    @eclass_info = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_info(student, course_number),
        key_array = %w(
          lecturename lecturepoint lecturecode lecturenum campcd subjectcode
          lecplansummary lecplanobject lecplanbook rateopenyn passtypename studyrate taskrate discussrate
          teamtaskrate testrate testrate2 testrate3 off1name off1rate off2name off2rate off3name off3rate
        ),
        filter_array = %w(msgCode),
        false, true
    )
    @eclass_info_name = %w(강의명 학점 과목번호 분반 캠퍼스 과목분류 강의요약 강의목표 교재/참고문헌 평가비율공개여부 평가방식 학습 과제 토론 중간고사 기말고사 퀴즈 )
    @eclass_students = get_eclass_students(student, course_number)#수강생 리스트 가져오기

    @eclass_notice_list = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_notice_list(student, course_number, 100), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username boardtitle userid boardno boarddate boardcheck boardhit), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
        filter_array = %w(msgCode),
        true, true
    )
    @eclass_notice_list.each do |notice| #get_eclass_notice_list 함수로 불러오는 chunk에는 lectureno 값이 없다. presenters_controller.rb/notice_detail 을 보게 되면 공지사항 글 세부 조회를 위해서 lectureno가 필요한데 결과 chunk에 없으므로 다시 [0~N][2]자리에 course_number 값을 넣어준다.
      notice[2] = course_number
    end

    @eclass_content_list = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_content_list(student, course_number),
        key_array = %w(lecschno lecschgroup dummy lecschtitle lecschtime attendyn lecschdate lecschfileintro),
        filter_array = %w(msgCode),
        true, true
    )
    @eclass_content_list.each do |content| #get_eclass_content_list 함수로 불러오는 chunk에는 lectureno 값이 없다. presenters_controller.rb/notice_detail 을 보게 되면 공지사항 글 세부 조회를 위해서 lectureno가 필요한데 결과 chunk에 없으므로 다시 [0~N][2]자리에 course_number 값을 넣어준다.
      content[2] = course_number
    end

    @eclass_share_list = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_share_list(student, course_number, 100), #eclass 과목 별 share 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username boardtitle userid boardno boarddate boardcheck boardhit), #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
        filter_array = %w(msgCode),
        true, true
    )
    @eclass_share_list.each do |share| #get_eclass_share_list 함수로 불러오는 chunk에는 lectureno 값이 없다. presenters_controller.rb/notice_detail 을 보게 되면 공지사항 글 세부 조회를 위해서 lectureno가 필요한데 결과 chunk에 없으므로 다시 [0~N][2]자리에 course_number 값을 넣어준다.
      share[2] = course_number
    end
  end

end