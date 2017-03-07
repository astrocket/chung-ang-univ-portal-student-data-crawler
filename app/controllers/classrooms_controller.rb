class ClassroomsController < ParsingController

  def show
    student = params[:student]
    course_name = params[:course].split('(')[0]
    professor = params[:professor]

    course_number = get_course_id(student, course_name, professor) #이렇게 코스 번호 불러오는 과정을 통신 없이 유저 데이터에서 빼오는걸로 바꿔야 한다.

    @student_data = get_user_data(student) #개인정보 가져오기
    @course_students = get_eclass_students(student, course_number)#수강생 리스트 가져오기
  end

  def eclass
    student = params[:student]
    @course_name = params[:course].split('(')[0] #이부분은 뷰에서 코스 이름을 가져와야함
    professor = params[:professor]

    course_number = get_course_id(student, @course_name, professor) #코스 번호 가져오기

    @notice = xml_map_chunk_extraction_job(
        map_chunk = get_eclass_notice(student, course_number, 100), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username boardtitle lectureno boardno boarddate boardcheck) #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
    )

  end

end