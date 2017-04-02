require 'test_helper'

class TimemachineControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timemachine_index_url
    assert_response :success
  end

end
