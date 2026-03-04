class ListingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :address, :measurement, :rooms, :bathrooms, :floors, :date_sold, :created_at, :updated_at

  has_many :listing_images
end
