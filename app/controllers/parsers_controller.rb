class ParsersController < ParsingController

  def index

  end

  def show
    student = params[:student]

    @student_data = get_user_data(student) #개인정보 가져오기
    @course_list = get_course_list(student) #수강 과목 리스트 가져오기 이거 년도/학기 별로 가져올 수 있게 코드 수정 필요
    @notice = xml_map_chunk_extraction_job(
        map_chunk = get_all_course_notice(student, 100), #eclass 과목 별 notice 리스트의 데이터 map chunk 를 가져온다. 맨 마지막 숫자를 조정해서 불러오는 공지사항의 개수 조절 가능
        key_array = %w(username lecturenameboardtitle lectureno boardno boarddate boardcheck) #해당 키값을 전부 뽑아서 2차월 배열에 넣어준다. @notice[0~N]에 분해 된 맵들이 각가 들어가고, 각 유닛의 2차원 배열 @notice[0][0~M]에 키값에 해당하는 밸류가 들어간다.
    )

    #관리자 계정용 정보 !!!!!!! Pundit 으로 반드시 권한 확인 후 코드 실행시켜야 속도 문제 줄어듦
    #@response = super_user_data(student)

  end


  def ask_notice_file
    require 'net/http'
    require 'uri'
    filename = params[:filename]
    filesysname = params[:filesysname]
    filetype = params[:filetype]

    url = 'http://cautis.cau.ac.kr/LMS/common/download.jsp'
    body = "fileName=#{filename}&fileSysName=#{filesysname}&fileDir=subDirLMSLms"
    send_data http_xform_post_job(url, body).body, filename: "#{filename}", type: "application/#{filetype}", stream: 'true', buffer_size: '4096'
  end

end
