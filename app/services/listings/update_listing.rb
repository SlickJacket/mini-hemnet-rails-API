module Listings
    class UpdateListing
        def initialize(listing, params)
            @listing = listing
            @params = params
        end

        def call
            if  @listing.update(@params)
                Success.new(@listing)
            else
                Failure.new(@listing.error.full_messages)
            end
        end

        Success = Struct.new(:listing)
        Failure = Struct.new(:errors)
    end
end
