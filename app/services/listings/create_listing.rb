module Listings
    class CreateListing
        def initialize(params)
            @params = params
        end

        def call
            listing = Listing.new(@params)

            if listing.save
                Success.new(listing)
            else
                Failure.new(listing.errors.full_messages)
            end
        end

        private

        attr_reader :params

        Success = Struct.new(:listing)
        Failure = Struct.new(:errors)
    end
end
