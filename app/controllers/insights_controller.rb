class InsightsController < ApplicationController
  before_action :set_listing

  def index
    query = InsightsQuery.new(listing: @listing, params: params)
    pagy, insights = pagy(query.raw)

    render json: {
      insights: insights,
      pagination: pagy_metadata(pagy)
    }
  end

  def summary
    query = InsightsQuery.new(listing: @listing, params: params)
    render json: query.summary
  end

  def timeseries
    query = InsightsQuery.new(listing: @listing, params: params)
    render json: query.timeseries
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end
end
