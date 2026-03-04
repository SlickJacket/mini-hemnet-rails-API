module Insights
  class TrendCalculator
    METRICS = %i[views saves inquiries].freeze

    def initialize(listing:, interval:)
      @listing = listing
      @interval = interval
      @query = InsightsQuery.new(listing: listing, params: { interval: interval })
    end

    def call
      current_period = @query.timeseries
      previous_period = @query.previous_timeseries

      METRICS.each_with_object({}) do |metric, hash|
        current_total = current_period[metric].values.sum
        previous_total = previous_period[metric].values.sum

        hash[metric] = Insights::Trend.new(
          current: current_total,
          previous: previous_total
        ).call
      end
    end
  end
end
