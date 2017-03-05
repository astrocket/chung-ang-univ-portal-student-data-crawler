class ClassroomsController < ApplicationController
  include ParsersHelper

  def show
    student = params[:student]
    course_name = params[:course].split('(')[0]

    classroom_number = find_class_number(student, course_name)
    @debug = classroom_number + course_name
    test_data = "<map><stdno value='#{student}'/><corscd value='0'/><campcd value='1'/><mjsust value='3B373'/><shyr value='4'/><shregst value='1'/><capyear value='2017'/><capshtm value='1'/><entncd value='13'/><shtmfg value='N'/><colg value='3B300'/><mj value='3B373'/><extrafg value='0'/><normalfg value='1'/><year value='2017'/><shtm value='1'/><delonlyfg value='N'/><cnclfg value='0'/></map>"
    info_data = "<map><id value='#{student}'/><usergb value='S'/></map>"
    classroom_data = "<map><lectureNo value='#{classroom_number}'/><userId value='#{student}'/><inqIndex value='inqAll'/><inqValue value=''/></map>"

    test_url = "http://sugang.cau.ac.kr/TIS/std/usk/sUskCap002/selectList.do"
    info_url = "https://cautis.cau.ac.kr/TIS/comm/SessionInfo/selectInfo.do"
    classroom_url = "http://cautis.cau.ac.kr/LMS/LMS/prof/lec/pLmsLec040/selectStudentList.do"

    @info = HTTParty.post(info_url, :headers=>{'Content-Type'=>'application/xml'},:body=>info_data).body.force_encoding('UTF-8')
    @test = HTTParty.post(test_url, :headers=>{'Content-Type'=>'application/xml'},:body=>test_data).body.force_encoding('UTF-8')
    @classroom = HTTParty.post(classroom_url, :headers=>{'Content-Type'=>'application/xml'},:body=>classroom_data).body.force_encoding('UTF-8')

  end

  private

  #정보가 뒤섞여서 날라오기 때문에 클래스넘버를 다른 곳에서 닫시 찾아야한다
  def find_class_number(student, course_name)
    course_data = "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='10'/><pageIndex value='1'/><kisuYear value='#{student.split(//).first(4).join.to_s}'/><kisuNo value='20171'/></map>"
    course_url = "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp050/selectStudDataInCourseList.do"
    course = HTTParty.post(course_url, :headers=>{'Content-Type'=>'application/xml'},:body=>course_data).body.force_encoding('UTF-8')

    resolve(course,'</map>').each do |k|
      if k.include?(course_name)
        return find_by_key(k, 'lectureno')
      end
    end
  end

end