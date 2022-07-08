require 'test_helper'

class UsersTimeoutControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get users_timeout_update_url
    assert_response :success
  end

end
