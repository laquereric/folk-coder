class HackathonsController < ApplicationController
  allow_unauthenticated_access

  def index
    @hackathons = Hackathon.upcoming
    @hackathons = @hackathons.search(params[:query])
    @hackathons = @hackathons.by_theme(params[:theme])
    @hackathons = @hackathons.by_location_type(params[:location_type])
    @hackathons = @hackathons.by_region(params[:region])

    @themes = Hackathon.distinct.pluck(:theme).compact.sort
    @location_types = Hackathon.distinct.pluck(:location_type).compact.sort
    @regions = Hackathon.distinct.pluck(:region).compact.sort
  end
end
