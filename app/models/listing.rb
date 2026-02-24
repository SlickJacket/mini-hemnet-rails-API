class Listing < ApplicationRecord
    has_many :insights, dependent: :destroy
    has_many :listing_images, dependent: :destroy

    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :address, presence: true
    validates :measurement, numericality: { greater_than: 0 }, allow_nil: true
    validates :rooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :bathrooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :floors, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
