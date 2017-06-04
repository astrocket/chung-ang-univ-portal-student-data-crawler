class ParserService
  def initialize(url, body)
    @url = url
    @body = body
  end

  def http_xml_post_job
    response = HTTParty.post(@url, :headers=>{'Content-Type'=>'application/xml'},:body=>@body).body.force_encoding('UTF-8')
  end

end