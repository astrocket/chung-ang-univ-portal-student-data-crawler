require 'test_helper'

class PresentersControllerTest < ActionDispatch::IntegrationTest
  test "should get notice_detail" do
    get presenters_notice_detail_url
    assert_response :success
  end

  test "should get notice_file" do
    get presenters_notice_file_url
    assert_response :success
  end

  test "should get fileboard_detail" do
    get presenters_fileboard_detail_url
    assert_response :success
  end

  test "should get fileboard_file" do
    get presenters_fileboard_file_url
    assert_response :success
  end

  test "should get professor_detail" do
    get presenters_professor_detail_url
    assert_response :success
  end

end
