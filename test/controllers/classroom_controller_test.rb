require 'test_helper'

class ClassroomControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get classroom_show_url
    assert_response :success
  end

end
