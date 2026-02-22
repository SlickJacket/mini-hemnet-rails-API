module Insights
    class RecordView
        def initialize(listing)
            @listing = listing
        end

        def call
            insight = @listing.insights.new(
                event_type: "view",
                occurred_at: Time.current
            )

            if insight.save
                Success.new(insight)
            else
                Failure.new(insight.error.full_messages)
            end
        end

        Success = Struct.new(:insight)
        Failure = Struct.new(:errors)
    end
end
