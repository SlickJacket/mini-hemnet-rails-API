module Insights
    class Summary
        def initialize(listing)
            @listing = listing
        end

        def call
            insights = @listing.insights

            Success.new(
                total_views: count(insights, "view"),
                total_saves: count(insights, "save"),
                total_inquiries: count(insights, "inquiry"),
                views_per_day: group_by_day(insights, "view")
            )
        end

        private

        def count(scope, event_type)
            scope.where(event_type: event_type).count
        end

        def group_by_day(scope, event_type)
            scope
                .where(event_type: event_type)
                .group("DATE(occurred_at)")
                .order("DATE(occurred_at)")
                .count
        end

        Success = Struct.new(:data)
    end
end
