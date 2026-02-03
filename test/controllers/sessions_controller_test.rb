require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "sign in page loads" do
    get new_session_path
    assert_response :success
    assert_select "h1", /Sign In/
  end

  test "successful login redirects to root" do
    post session_path, params: {
      email_address: users(:alice).email_address,
      password: "password123"
    }
    assert_redirected_to root_path
  end

  test "failed login redirects back with alert" do
    post session_path, params: {
      email_address: users(:alice).email_address,
      password: "wrongpassword"
    }
    assert_redirected_to new_session_path
    follow_redirect!
    assert_select ".text-red-400"
  end

  test "logout destroys session" do
    sign_in users(:alice)
    delete session_path
    assert_redirected_to new_session_path
  end
end
