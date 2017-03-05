require 'httparty'
require 'multi_xml'
class ParserController < ApplicationController
  include HTTParty
  format :xml

  def index


  end

  def show
    student = params[:student]

    test_data = "<map><serchstdno value='#{student}'/><stdno value='#{student}'/></map>"
    info_data = "<map><id value='#{student}'/><usergb value='S'/></map>"
    course_data = "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='10'/><pageIndex value='1'/><kisuYear value='#{student.split(//).first(4).join.to_s}'/><kisuNo value='20171'/></map>"

    test_url = "https://cautis.cau.ac.kr/TIS/std/uhs/sUhsPer001Tab01/selectList.do"
    info_url = "https://cautis.cau.ac.kr/TIS/comm/SessionInfo/selectInfo.do"
    course_url = "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp050/selectStudDataInCourseList.do"

    @info = HTTParty.post(info_url, :headers=>{'Content-Type'=>'application/xml'},:body=>info_data).body
    @course = HTTParty.post(course_url, :headers=>{'Content-Type'=>'application/xml'},:body=>course_data).body
    @test = HTTParty.post(test_url, :headers=>{'Content-Type'=>'application/xml'},:body=>test_data).body

  end

  def showed
    student = params[:student]

    data = "<map><serchstdno value='#{student}'/><stdno value='#{student}'/></map>"
    url = []
    @response = []

    1.upto(8).each do |l|
      url[l] = "https://cautis.cau.ac.kr/TIS/std/uhs/sUhsPer001Tab0#{l}/selectList.do"
      @response[l] = HTTParty.post(
          url[l],
          :headers => {
              'Content-Type' => 'application/xml'
          },
          :body => data
      )
    end
  end

end
