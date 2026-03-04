module Insights
  class Trend
    def initialize(current:, previous:)
      @current = current.to_f
      @previous = previous.to_f
    end

    def call
      return 0.0 if @current.zero? && @previous.zero?
      return 100.0 if @previous.zero? && @current > 0
      return -100.0 if @previous > 0 && @current.zero?

      (((@current - @previous) / @previous) * 100).round(2)
    end
  end
end
