require "test_helper"

class HackathonTest < ActiveSupport::TestCase
  test "upcoming scope excludes past hackathons" do
    upcoming = Hackathon.upcoming
    assert_not_includes upcoming, hackathons(:past_hack)
  end

  test "upcoming scope includes future hackathons" do
    upcoming = Hackathon.upcoming
    assert_includes upcoming, hackathons(:hackmit)
  end

  test "upcoming scope orders by start_date" do
    upcoming = Hackathon.upcoming
    dates = upcoming.map(&:start_date)
    assert_equal dates, dates.sort
  end

  test "by_theme filters correctly" do
    results = Hackathon.by_theme("AI & Machine Learning")
    assert_includes results, hackathons(:hackmit)
    assert_includes results, hackathons(:global_hack_week)
    assert_not_includes results, hackathons(:climate_hack)
  end

  test "by_theme returns all when blank" do
    assert_equal Hackathon.count, Hackathon.by_theme("").count
    assert_equal Hackathon.count, Hackathon.by_theme(nil).count
  end

  test "by_location_type filters correctly" do
    results = Hackathon.by_location_type("Virtual")
    assert_includes results, hackathons(:global_hack_week)
    assert_not_includes results, hackathons(:hackmit)
  end

  test "search matches name" do
    results = Hackathon.search("HackMIT")
    assert_includes results, hackathons(:hackmit)
    assert_not_includes results, hackathons(:climate_hack)
  end

  test "search matches description" do
    results = Hackathon.search("climate change")
    assert_includes results, hackathons(:climate_hack)
  end

  test "search returns all when blank" do
    assert_equal Hackathon.count, Hackathon.search("").count
    assert_equal Hackathon.count, Hackathon.search(nil).count
  end

  test "by_region filters correctly" do
    results = Hackathon.by_region("Europe")
    assert_includes results, hackathons(:hackzurich)
    assert_not_includes results, hackathons(:hackmit)
  end

  test "by_region returns all when blank" do
    assert_equal Hackathon.count, Hackathon.by_region("").count
    assert_equal Hackathon.count, Hackathon.by_region(nil).count
  end

  test "by_country filters correctly" do
    results = Hackathon.by_country("Switzerland")
    assert_includes results, hackathons(:hackzurich)
    assert_not_includes results, hackathons(:hackmit)
  end

  test "search matches region" do
    results = Hackathon.search("Europe")
    assert_includes results, hackathons(:hackzurich)
  end

  test "search matches country" do
    results = Hackathon.search("Switzerland")
    assert_includes results, hackathons(:hackzurich)
  end
end
