class Insight < ApplicationRecord
  belongs_to :listing

  EVENT_TYPES = %w[view save inquiry].freeze
  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
  validates :occurred_at, presence: true
end
