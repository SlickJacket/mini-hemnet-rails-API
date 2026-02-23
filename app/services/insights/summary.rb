require "ostruct"

module Insights
  class Summary
    def initialize(listing)
      @listing = listing
    end

    def call
      events = Insight.where(listing_id: @listing.id)

      OpenStruct.new(
        total_views: count(events, "view"),
        total_saves: count(events, "save"),
        total_inquiries: count(events, "inquiry"),
        funnel: funnel(events),
        engagement_score: engagement_score(events)
      )
    end

    private

    def count(events, type)
      events.where(event_type: type).count
    end

    def funnel(events)
      {
        views: count(events, "view"),
        saves: count(events, "save"),
        inquiries: count(events, "inquiry")
      }
    end

    # Simple engagement score (Hemnet uses something similar)
    # You can tune this later
    def engagement_score(events)
      views = count(events, "view")
      saves = count(events, "save")
      inquiries = count(events, "inquiry")

      return 0 if views == 0

      # Weighted formula
      (((saves * 2) + (inquiries * 4)) / views.to_f).round(1)
    end
  end
end
