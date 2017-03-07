class ParsingController < ApplicationController
  include ParsingHelper

  #파싱과 관련 된 컨트롤러 함수들 모음

  require 'httparty'
  require 'multi_xml'

  def http_xml_post_job(url, body)

    response = HTTParty.post(url, :headers=>{'Content-Type'=>'application/xml'},:body=>body).body.force_encoding('UTF-8')
    if response.nil?
      flash[:error] = '요청하신 값을 가져오는데 실패하였습니다. 에러 : http_xml_post_job failed'
    else
      response
    end
  end

  def http_xml_post_job_d(url, body)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/xml'})
    request.body = body
    http.use_ssl = true if url =~ /^https/
    response = http.request(request).body.force_encoding('UTF-8')
    if response.nil?
      flash[:error] = '요청하신 값을 가져오는데 실패하였습니다. 에러 : http_xform_post_job failed'
    else
      response
    end
  end

  #이부분은 클라이언트 사이드로 넘겨야 한다.
  def http_xform_post_job(url, body)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/x-www-form-urlencoded'})
    request.body = body
    response = http.request(request)
    if response.nil?
      flash[:error] = '요청하신 값을 가져오는데 실패하였습니다. 에러 : http_xform_post_job failed'
    else
      response
    end
  end

  # one-depth map 속에 또 map 이 있는 구조이면 이 함수로 분해할 수 없다.
  def xml_map_chunk_extraction_job(map_chunk, key_array)
    value_array = []
    resolve_xml(map_chunk, '</map>').each_with_index do |map, i|
      if filter_by_sub_string(map, 'msgCode') #msg 쓰레기값 제거
        value_array[i] = []
        key_array.each_with_index do |key, m|
          value_array[i][m] = find_by_key(map, key) #해당 키값의 밸류를 추출한다.
        end
      end
    end
    value_array
  end

  #ask 함수
  def ask_notice_detail #공지사항 리스트에서 클릭 된 공지사항에 대해서 세부 사항을 가져오는 부분
    student = params[:student]
    course_unit = params[:course_unit]

    @notice_detail = get_course_notice_detail(student, course_unit)
  end

  #get 함수

  def get_user_data(student)
    url = 'https://cautis.cau.ac.kr/TIS/comm/SessionInfo/selectInfo.do'
    body = "<map><id value='#{student}'/><usergb value='S'/></map>"
    http_xml_post_job(url, body)
  end

  def get_course_id(student, course_name, course_professor) #정보가 뒤섞여서 날라오기 때문에 클래스넘버를 다른 곳에서 닫시 찾아야한다. 값 하나만 딱 찾아서 리턴하는것이므로
    url = "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp050/selectStudDataInCourseList.do"
    body = "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='15'/><pageIndex value='1'/><kisuYear value='#{student.split(//).first(4).join.to_s}'/><kisuNo value='20171'/></map>"

    resolve_xml(http_xml_post_job(url, body), '</map>').each do |k| #한글강의명과 교수이름이 일치하면 lectureno 가 리턴됨 찾는중임. 만약에 같은 교수명에 이름도 거의 똑같은 이름의 수업일 경우 에러 날 수도 있음
      if k.include?(course_name)
        if k.include?(course_professor)
          return find_by_key(k, 'lectureno')
        end
      end
    end
  end

  def get_course_list(student)
    url = 'http://sugang.cau.ac.kr/TIS/std/usk/sUskCap002/selectList.do'
    body = "<map><stdno value='#{student}'/><corscd value='0'/><campcd value='1'/><mjsust value='3B373'/><shyr value='4'/><shregst value='1'/><capyear value='2017'/><capshtm value='1'/><entncd value='13'/><shtmfg value='N'/><colg value='3B300'/><mj value='3B373'/><extrafg value='0'/><normalfg value='1'/><year value='2017'/><shtm value='1'/><delonlyfg value='N'/><cnclfg value='0'/></map>"
    http_xml_post_job(url, body)
  end

  def get_all_course_notice(student, how_many) #공지사항 리스트 가져오기(세부 텍스트는 가져오지 않는다.)
    url = 'http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp030/selectStudLectureNoticeList.do'
    body = "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='#{how_many}'/><pageIndex value='1'/></map>"
    http_xml_post_job(url, body)
  end

  def get_course_notice_detail(student, course_unit)
    url = 'http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp030/getLectureNotice.do'
    body = "<map><userId value='#{student}'/><groupCode value='cau'/><lectureNo value='#{course_unit[2]}'/><boardNo value='#{course_unit[3]}'/></map>"
    http_xml_post_job(url, body)
  end

  def get_eclass_students(student, course_number)
    url = 'http://cautis.cau.ac.kr/LMS/LMS/prof/lec/pLmsLec040/selectStudentList.do'
    body = "<map><lectureNo value='#{course_number}'/><userId value='#{student}'/><inqIndex value='inqAll'/><inqValue value=''/></map>"
    http_xml_post_job(url, body)
  end

  def get_eclass_professor
    url = ''
    body = ""
    http_xml_post_job(url, body)
  end

  def get_eclass_info
    url = ''
    body = ""
    http_xml_post_job(url, body)
  end

  def get_eclass_notice(student, course_number, how_many)
    url = 'http://cautis.cau.ac.kr/LMS/LMS/prof/lec/pLmsLec070/selectLectureBoardList.do'
    body = "<map><userId value='#{student}'/><lectureNo value='#{course_number}'/><boardType value='NOTICE'/><recordCountPerPage value='#{how_many}'/><pageIndex value='1'/><searchWord value=''/><searchType value='inqAll'/></map>"
    http_xml_post_job(url, body)
  end

  def get_eclass_fileboard
    url = ''
    body = ""
    http_xml_post_job(url, body)
  end

  #super user functions after authorizing super user

  def super_user_data(student)
    url = []
    body = "<map><serchstdno value='#{student}'/><stdno value='#{student}'/></map>"
    response = []

    1.upto(8).each do |l|
      url[l] = "https://cautis.cau.ac.kr/TIS/std/uhs/sUhsPer001Tab0#{l}/selectList.do"
      response[l] = http_xml_post_job(url[l], body)
    end
    response
  end

end
