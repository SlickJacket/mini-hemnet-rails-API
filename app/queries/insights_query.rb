class InsightsQuery
  attr_reader :listing, :params

  def initialize(listing:, params:)
    @listing = listing
    @params = params || {}
  end

  def raw
    Insight.where(listing_id: listing.id).order(occurred_at: :desc)
  end

  def summary
    raw.group(:event_type).count
  end

  # -----------------------------
  # TIMESERIES
  # -----------------------------
  def timeseries
    interval = normalized_interval

    case interval
    when "day"   then group_by_day
    when "week"  then group_by_week
    when "month" then group_by_month
    else group_by_day
    end
  end

def trend
  interval = normalized_interval

  current = timeseries
  previous = previous_timeseries

  {
    views: percent_change(previous[:views].values.sum, current[:views].values.sum),
    saves: percent_change(previous[:saves].values.sum, current[:saves].values.sum),
    inquiries: percent_change(previous[:inquiries].values.sum, current[:inquiries].values.sum)
  }
end

def previous_timeseries
  interval = normalized_interval

  shifted_raw =
    case interval
    when "day"
      raw.where(occurred_at: 1.day.ago.beginning_of_day..Time.current)
    when "week"
      raw.where(occurred_at: 1.week.ago.beginning_of_week..Time.current)
    when "month"
      raw.where(occurred_at: 1.month.ago.beginning_of_month..Time.current)
    end

  {
    views: shifted_raw.where(event_type: "view").group_by_period(interval, :occurred_at).count,
    saves: shifted_raw.where(event_type: "save").group_by_period(interval, :occurred_at).count,
    inquiries: shifted_raw.where(event_type: "inquiry").group_by_period(interval, :occurred_at).count
  }
end

  private

  # -----------------------------
  # HELPERS
  # -----------------------------
  def normalized_interval
    case params[:interval]&.downcase
    when "day", "daily" then "day"
    when "week", "weekly" then "week"
    when "month", "monthly" then "month"
    else "day"
    end
  end

  def group_by_day
    {
      views: raw.where(event_type: "view").group_by_day(:occurred_at).count,
      saves: raw.where(event_type: "save").group_by_day(:occurred_at).count,
      inquiries: raw.where(event_type: "inquiry").group_by_day(:occurred_at).count
    }
  end

  def group_by_week
    {
      views: raw.where(event_type: "view").group_by_week(:occurred_at).count,
      saves: raw.where(event_type: "save").group_by_week(:occurred_at).count,
      inquiries: raw.where(event_type: "inquiry").group_by_week(:occurred_at).count
    }
  end

  def group_by_month
    {
      views: raw.where(event_type: "view").group_by_month(:occurred_at).count,
      saves: raw.where(event_type: "save").group_by_month(:occurred_at).count,
      inquiries: raw.where(event_type: "inquiry").group_by_month(:occurred_at).count
    }
  end

  def percent_change(previous, current)
    return 0.0 if previous == 0 && current == 0
    return 100.0 if previous == 0 && current > 0
    return -100.0 if previous > 0 && current == 0

    (((current - previous) / previous.to_f) * 100).round(1)
  end
end
