require 'httparty'
require 'multi_xml'
class ParserController < ApplicationController
  include HTTParty
  format :xml

  def index


  end

  def show
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
