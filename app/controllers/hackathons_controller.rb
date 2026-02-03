class HackathonsController < ApplicationController
  allow_unauthenticated_access

  def index
    @hackathons = Hackathon.upcoming
    @hackathons = @hackathons.search(params[:query])
    @hackathons = @hackathons.by_theme(params[:theme])
    @hackathons = @hackathons.by_location_type(params[:location_type])

    @themes = Hackathon.distinct.pluck(:theme).compact.sort
    @location_types = Hackathon.distinct.pluck(:location_type).compact.sort
  end
end
