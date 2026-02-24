class CreateListingImages < ActiveRecord::Migration[8.1]
  def change
    create_table :listing_images do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
