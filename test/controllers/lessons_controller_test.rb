require "test_helper"

class LessonsControllerTest < ActionDispatch::IntegrationTest
  test "redirects to sign in when not authenticated" do
    get lesson_path(id: lessons(:multi_repo))
    assert_redirected_to new_session_path
  end

  test "shows lesson when authenticated" do
    sign_in users(:alice)
    get lesson_path(id: lessons(:multi_repo))
    assert_response :success
    assert_select "h1", /Understanding Multi-Repo Architecture/
  end

  test "shows completed status for completed lesson" do
    sign_in users(:alice)
    get lesson_path(id: lessons(:multi_repo))
    assert_match /Completed/, response.body
  end

  test "shows mark complete button for incomplete lesson" do
    sign_in users(:alice)
    get lesson_path(id: lessons(:secrets))
    assert_match "Mark Complete", response.body
  end

  test "completing a lesson creates lesson_completion" do
    sign_in users(:bob)
    assert_difference "LessonCompletion.count", 1 do
      post complete_lesson_path(id: lessons(:multi_repo))
    end
  end

  test "completing a lesson redirects to next lesson" do
    sign_in users(:bob)
    post complete_lesson_path(id: lessons(:multi_repo))
    assert_redirected_to lesson_path(id: lessons(:secrets))
  end

  test "completing last lesson redirects to curriculum" do
    sign_in users(:bob)
    post complete_lesson_path(id: lessons(:docker))
    assert_redirected_to curriculum_path
  end
end
