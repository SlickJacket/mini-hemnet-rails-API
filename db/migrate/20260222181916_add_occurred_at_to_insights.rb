class AddOccurredAtToInsights < ActiveRecord::Migration[8.1]
  def change
    add_column :insights, :occurred_at, :datetime
  end
end
