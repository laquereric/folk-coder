require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page loads" do
    get root_path
    assert_response :success
    assert_select "h1", /Never Hack/
  end

  test "home page has registration links" do
    get root_path
    assert_select "a[href=?]", new_registration_path, minimum: 1
  end

  test "home page has hackathons link" do
    get root_path
    assert_select "a[href=?]", hackathons_path
  end

  test "next page loads" do
    get next_path
    assert_response :success
    assert_select "h1", /Congratulations/
  end

  test "next page has registration link" do
    get next_path
    assert_select "a[href=?]", new_registration_path
  end

  test "faq page loads" do
    get faq_path
    assert_response :success
    assert_match "Hacking", response.body
    assert_match "Hackathon", response.body
  end
end
