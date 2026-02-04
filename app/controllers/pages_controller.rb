class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
    @user_count = User.count
    @hackathon_count = Hackathon.count
  end

  def next_page
  end

  def faq
  end

  def ai_risks_benefits
  end
end
