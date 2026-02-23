class InsightsQuery
  def initialize(listing:, params:)
    @listing = listing
    @params = params
  end

  def raw
    Insight.where(listing_id: @listing.id)
           .order(occurred_at: :desc)
  end

  def summary
    raw.group(:event_type).count
  end

  def timeseries
    raw.group_by_day(:occurred_at).count
  end
end
