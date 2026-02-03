require "test_helper"

class CurriculumControllerTest < ActionDispatch::IntegrationTest
  test "redirects to sign in when not authenticated" do
    get curriculum_path
    assert_redirected_to new_session_path
  end

  test "shows dashboard when authenticated" do
    sign_in users(:alice)
    get curriculum_path
    assert_response :success
    assert_select "h1", /SwarmPod Curriculum/
  end

  test "shows progress bar" do
    sign_in users(:alice)
    get curriculum_path
    assert_match "Your Progress", response.body
  end

  test "shows lesson titles" do
    sign_in users(:alice)
    get curriculum_path
    assert_match "Understanding Multi-Repo Architecture", response.body
    assert_match "Secrets Management", response.body
  end
end
