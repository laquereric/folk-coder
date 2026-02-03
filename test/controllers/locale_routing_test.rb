require "test_helper"

class LocaleRoutingTest < ActionDispatch::IntegrationTest
  test "Spanish root loads" do
    get "/es"
    assert_response :success
  end

  test "French hackathons loads" do
    get "/fr/hackathons"
    assert_response :success
  end

  test "Portuguese FAQ loads" do
    get "/pt/faq"
    assert_response :success
  end

  test "explicit English prefix works" do
    get "/en/hackathons"
    assert_response :success
  end

  test "invalid locale prefix does not set locale" do
    # /xx/hackathons doesn't match the locale constraint, so Rails
    # treats it as a non-locale route. It will either 404 or fall
    # through. We just verify it doesn't render with locale "xx".
    begin
      get "/xx/hackathons"
      # If it didn't raise, the response should not have locale xx
      refute_equal :xx, I18n.locale
    rescue ActionController::RoutingError
      # This is also acceptable — the route simply doesn't exist
      pass
    end
  end

  test "language switcher links present on home page" do
    get root_path
    assert_response :success
    assert_select "[data-testid=language-switcher]"
    assert_match "Español", response.body
    assert_match "Français", response.body
    assert_match "Português", response.body
  end

  test "language switcher present on Spanish page" do
    get "/es"
    assert_response :success
    assert_select "[data-testid=language-switcher]"
    assert_match "English", response.body
  end

  test "Spanish hackathons page shows Spanish title" do
    get "/es/hackathons"
    assert_response :success
    assert_match "Centro de Hackathons", response.body
  end

  test "English URLs have no locale prefix" do
    get root_path
    assert_response :success
    # Links should not contain /en/ prefix
    assert_select "a[href='/hackathons']", minimum: 1
  end

  test "html lang attribute matches locale" do
    get "/fr/faq"
    assert_response :success
    assert_select "html[lang=fr]"
  end

  test "html lang attribute is en by default" do
    get root_path
    assert_response :success
    assert_select "html[lang=en]"
  end
end
