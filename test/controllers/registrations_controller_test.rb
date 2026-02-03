require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new registration form loads" do
    get new_registration_path
    assert_response :success
    assert_select "h1", /Create Your Account/
  end

  test "successful registration creates user and logs in" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          name: "Test User",
          email_address: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select "span", "Test User"
  end

  test "registration with mismatched passwords shows errors" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          name: "Test",
          email_address: "test@example.com",
          password: "password123",
          password_confirmation: "mismatch"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "registration with duplicate email shows error" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          name: "Duplicate",
          email_address: users(:alice).email_address,
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
