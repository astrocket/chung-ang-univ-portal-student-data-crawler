require 'test_helper'

class ParserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parser_index_url
    assert_response :success
  end

  test "should get show" do
    get parser_show_url
    assert_response :success
  end

end
