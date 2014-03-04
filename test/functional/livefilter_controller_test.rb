require 'test_helper'

class LivefilterControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get data" do
    get :data
    assert_response :success
  end

  test "should get adddata" do
    get :adddata
    assert_response :success
  end

end
