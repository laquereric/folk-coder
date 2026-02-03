require "test_helper"

class HackathonsControllerTest < ActionDispatch::IntegrationTest
  test "index loads without authentication" do
    get hackathons_path
    assert_response :success
    assert_select "h1", /Hackathon Hub/
  end

  test "shows upcoming hackathons" do
    get hackathons_path
    assert_select ".rounded-xl", minimum: 1
    assert_match "HackMIT 2026", response.body
  end

  test "does not show past hackathons" do
    get hackathons_path
    assert_no_match "Old Hackathon", response.body
  end

  test "filters by theme" do
    get hackathons_path, params: { theme: "AI & Machine Learning" }
    assert_response :success
    assert_match "HackMIT 2026", response.body
    assert_no_match "Climate Hack 2026", response.body
  end

  test "filters by location type" do
    get hackathons_path, params: { location_type: "Virtual" }
    assert_response :success
    assert_match "Global Hack Week", response.body
    assert_no_match "HackMIT 2026", response.body
  end

  test "search by name" do
    get hackathons_path, params: { query: "Climate" }
    assert_response :success
    assert_match "Climate Hack 2026", response.body
    assert_no_match "HackMIT 2026", response.body
  end

  test "has filter dropdowns" do
    get hackathons_path
    assert_select "select[name=theme]"
    assert_select "select[name=location_type]"
  end

  test "shows location type badges" do
    get hackathons_path
    assert_match "In Person", response.body
    assert_match "Virtual", response.body
  end

  test "has region filter dropdown" do
    get hackathons_path
    assert_select "select[name=region]"
  end

  test "filters by region" do
    get hackathons_path, params: { region: "Europe" }
    assert_response :success
    assert_match "HackZurich 2026", response.body
    assert_no_match "HackMIT 2026", response.body
  end
end
