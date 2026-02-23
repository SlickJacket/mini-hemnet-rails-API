class InsightSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :occurred_at, :created_at
end
