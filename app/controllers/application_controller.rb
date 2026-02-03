class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  APP_VERSION = Rails.root.join("VERSION").read.strip
  GIT_SHA = ENV.fetch("GIT_SHA") { `git rev-parse --short HEAD 2>/dev/null`.strip.presence || "dev" }

  before_action :set_locale

  def default_url_options
    { locale: I18n.locale == :en ? nil : I18n.locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || :en
  end
end
