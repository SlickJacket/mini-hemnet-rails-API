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
    result = Insights::Summary.new(@listing).call

    trend = Insights::TrendCalculator.new(
      listing: @listing,
      interval: params[:interval] || "daily"
    ).call

    render json: {
      total_views: result.total_views,
      total_saves: result.total_saves,
      total_inquiries: result.total_inquiries,
      funnel: result.funnel,
      engagement_score: result.engagement_score,
      trend: trend
    }
  end

  def timeseries
    query = InsightsQuery.new(listing: @listing, params: params)

    trend = Insights::TrendCalculator.new(
      listing: @listing,
      interval: params[:interval] || "daily"
    ).call

    render json: {
      interval: params[:interval] || "daily",
      data: query.timeseries,
      trend: trend
    }
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end
end
