class ListingsController < ApplicationController
  include Pagy::Backend
  include Pagy::Frontend

  before_action :set_listing, only: [ :show, :update, :destroy, :view, :save_event, :inquiry ]

  # GET /listings
  def index
    listings = ListingsQuery.new(params).call
    pagy, listings = pagy(listings)

    render json: {
    listings: ActiveModelSerializers::SerializableResource.new(listings, each_serializer: ListingSerializer),
    pagination: pagy_metadata(pagy)
    }, status: :ok
  end


  # GET /listings/:id
  def show
    render json: @listing, status: :ok
  end

  # POST /listings
  def create
    result = Listings::CreateListing.new(listing_params).call

    if result.is_a?(Listings::CreateListing::Success)
      render json: result.listing, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listings/:id
  def update
    result = Listings::UpdateListing.new(@listing, listing_params).call

    if result.is_a?(Listings::UpdateListing::Success)
      render json: result.listing, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /listings/:id
  def destroy
    @listing.destroy
    head :no_content
  end

  # POST /listings/:id/view
  def view
    result = Insights::RecordView.new(@listing).call
    render json: result.insight, status: :created
  end

  # POST /listings/:id/save_event
  def save_event
    result = Insights::RecordSave.new(@listing).call
    render json: result.insight, status: :created
  end

  # POST /listings/:id/inquiry
  def inquiry
    result = Insights::RecordInquiry.new(@listing).call
    render json: result.insight, status: :created
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(
      :title, :description, :price, :address,
      :measurement, :rooms, :bathrooms, :floors, :date_sold
    )
  end
end
