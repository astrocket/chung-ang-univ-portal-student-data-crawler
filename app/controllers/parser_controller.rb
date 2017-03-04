require 'httparty'
require 'multi_xml'
class ParserController < ApplicationController
  include HTTParty
  format :xml

  def index


  end

  def show
    student = params[:student]

    data = [
        "<map><id value=value='#{student}'/><usergb value='S'/>",
        "<map><userId value='#{student}'/><groupCode value='cau'/><recordCountPerPage value='10'/><pageIndex value='1'/><kisuYear value='#{student.split("").first(4)}'/><kisuNo value='20171'/></map>"
    ]

    url = [
        "https://cautis.cau.ac.kr/TIS/comm/SessionInfo/selectInfo.do",
        "http://cautis.cau.ac.kr/LMS/LMS/prof/myp/pLmsMyp050/selectStudDataInCourseList.do"
    ]

    @response = []

    data.length.times do |l|
      @response[l] = HTTParty.post(
          url[l],
          :headers => {
              'Content-Type' => 'application/xml'
          },
          :body => data[l]
      )
    end

  end
end
