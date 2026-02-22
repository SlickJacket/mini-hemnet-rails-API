module Insights
    class RecordSave
        def initialize(listing)
            @listing = listing
        end

        def call
            insight = @lising.insight.new(
                event_type: "save",
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
