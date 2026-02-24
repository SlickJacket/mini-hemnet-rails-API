class ListingImagesController < ApplicationController
  before_action :set_listing

  def index
    render json: @listing.listing_images
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end
end
