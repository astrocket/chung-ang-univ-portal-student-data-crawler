require 'httparty'
require 'multi_xml'
class ParsersController < ApplicationController
  include ParsersHelper

  def index

  end

  def show
    student = params[:student]

    course_data = "<map><stdno value='#{student}'/><corscd value='0'/><campcd value='1'/><mjsust value='3B373'/><shyr value='4'/><shregst value='1'/><capyear value='2017'/><capshtm value='1'/><entncd value='13'/><shtmfg value='N'/><colg value='3B300'/><mj value='3B373'/><extrafg value='0'/><normalfg value='1'/><year value='2017'/><shtm value='1'/><delonlyfg value='N'/><cnclfg value='0'/></map>"
    info_data = "<map><id value='#{student}'/><usergb value='S'/></map>"

    course_url = "http://sugang.cau.ac.kr/TIS/std/usk/sUskCap002/selectList.do"
    info_url = "https://cautis.cau.ac.kr/TIS/comm/SessionInfo/selectInfo.do"

    @info = HTTParty.post(info_url, :headers=>{'Content-Type'=>'application/xml'},:body=>info_data).body.force_encoding('UTF-8')
    @course = HTTParty.post(course_url, :headers=>{'Content-Type'=>'application/xml'},:body=>course_data).body.force_encoding('UTF-8')
    @notice = get_notice(student)

  end

  def get_notice(student)

    notice = []
    notice_data = "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='10'/><pageIndex value='1'/></map>"
    notice_url = "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp030/selectStudLectureNoticeList.do"

    notice_list = HTTParty.post(notice_url, :headers=>{'Content-Type'=>'application/xml'},:body=>notice_data).body.force_encoding('UTF-8')
    resolve(notice_list,'</map>').each_with_index do |k, i|
      if filter_by_subdata(k, 'msg')
        notice[i] = []
        notice[i][0] = find_by_key(k, 'lecturename')
        notice[i][1] = find_by_key(k, 'boardtitle')
        notice[i][2] = find_by_key(k, 'lectureno')
        notice[i][3] = find_by_key(k, 'boardno')
      end
    end

    notice
  end

  def get_notice_detail
    student = params[:student]
    notice_unit = params[:notice]
    notice_detail_data = "<map><userId value='#{student}'/><groupCode value='cau'/><lectureNo value='#{notice_unit[2]}'/><boardNo value='#{notice_unit[3]}'/></map>"
    notice_detail_url = "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp030/getLectureNotice.do"

    notice_detail = HTTParty.post(notice_detail_url, :headers=>{'Content-Type'=>'application/xml'},:body=>notice_detail_data).body.force_encoding('UTF-8')

    notice_unit[4] = find_by_key(notice_detail, 'textcontent')

    @notice_with_detail = notice_unit
  end

  def dummy
    course_simple_data = "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='10'/><pageIndex value='1'/><kisuYear value='#{student.split(//).first(4).join.to_s}'/><kisuNo value='20171'/></map>"
    course_simple_url = "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp050/selectStudDataInCourseList.do"
    @course_simple = HTTParty.post(course_simple_url, :headers=>{'Content-Type'=>'application/xml'},:body=>course_simple_data).body.force_encoding('UTF-8')

  end
end
