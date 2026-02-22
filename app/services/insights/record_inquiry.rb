module Insights
    class RecordInquiry
        def initialize(listing)
            @listing = listing
        end

        def call
            insight = @listing.insights.new(
                event_type: "inquiry",
                occurred_at: Time.current
            )

            if insight.save
                Success.new(insight)
            else
                Failure.new(insight.errors.full_messages)
            end
        end

        Success = Struct.new(:insight)
        Failure = Struct.new(:errors)
    end
end
