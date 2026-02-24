class Insight < ApplicationRecord
  belongs_to :listing
  after_commit :invalidate_cache, on: :create

  EVENT_TYPES = %w[view save inquiry].freeze
  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
  validates :occurred_at, presence: true

  private

  def invalidate_cache
    Rails.cache.delete("listing:#{listing_id}:insights:summary")
    Rails.cache.delete("listing:#{listing_id}:insights:timeseries:day")
    Rails.cache.delete("listing:#{listing_id}:insights:timeseries:week")
    Rails.cache.delete("listing:#{listing_id}:insights:timeseries:month")
  end
end
