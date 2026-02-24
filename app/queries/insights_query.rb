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
        Rails.cache.fetch(timeseries_cache_key, expires_in: 10.minutes) do
            interval = (@params[:interval] || "day").downcase

            case interval
            when "day", "daily"
                        group_by_day
            when "week", "weekly"
                        group_by_week
            when "month", "monthly"
                        group_by_month
            else
                        group_by_day
            end
        end
    end

    def trend
    today = Date.today

    this_week_start = today - 7
    prev_week_start = today - 14

    this_week = raw.where("occurred_at >= ?", this_week_start)
    prev_week = raw.where("occurred_at >= ? AND occurred_at < ?", prev_week_start, this_week_start)

    {
        views: percent_change(prev_week.where(event_type: "view").count,
                            this_week.where(event_type: "view").count),
        saves: percent_change(prev_week.where(event_type: "save").count,
                            this_week.where(event_type: "save").count),
        inquiries: percent_change(prev_week.where(event_type: "inquiry").count,
                                this_week.where(event_type: "inquiry").count)
    }
    end


    private

    def timeseries_cache_key
        interval = (@params[:interval] || "day").downcase
        "listing:#{@listing.id}:insights:timeseries:#{interval}"
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
    return 0.0 if previous == 0
    (((current - previous) / previous.to_f) * 100).round(1)
    end
end
