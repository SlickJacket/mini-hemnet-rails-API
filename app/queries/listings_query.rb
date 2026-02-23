class ListingsQuery
  SORT_OPTIONS = {
    "price_asc"        => { price: :asc },
    "price_desc"       => { price: :desc },
    "rooms_asc"        => { rooms: :asc },
    "rooms_desc"       => { rooms: :desc },
    "size_asc"         => { measurement: :asc },
    "size_desc"        => { measurement: :desc },
    "newest"           => { created_at: :desc },
    "oldest"           => { created_at: :asc }
  }.freeze

  def initialize(params = {})
    @params = params
  end

  def call
    scope = Listing.all

    scope = scope.where("price >= ?", @params[:min_price]) if @params[:min_price].present?
    scope = scope.where("price <= ?", @params[:max_price]) if @params[:max_price].present?

    scope = scope.where("rooms >= ?", @params[:min_rooms]) if @params[:min_rooms].present?
    scope = scope.where("rooms <= ?", @params[:max_rooms]) if @params[:max_rooms].present?

    scope = scope.where("bathrooms >= ?", @params[:min_bathrooms]) if @params[:min_bathrooms].present?
    scope = scope.where("bathrooms <= ?", @params[:max_bathrooms]) if @params[:max_bathrooms].present?

    scope = scope.where("measurement >= ?", @params[:min_measurement]) if @params[:min_measurement].present?
    scope = scope.where("measurement <= ?", @params[:max_measurement]) if @params[:max_measurement].present?

    # Area filter
    if @params[:area].present?
        area = @params[:area].strip.downcase

        adapter = ActiveRecord::Base.connection.adapter_name.downcase

        if adapter.include?("sqlite")
            scope = scope.where("LOWER(address) LIKE ?", "%#{area}%")
        else
            scope = scope.where("address ILIKE ?", "%#{area}%")
        end
    end



    # Sold filter
    if @params[:sold].present?
      sold_value = ActiveModel::Type::Boolean.new.cast(@params[:sold])
      scope = scope.where.not(date_sold: nil) if sold_value
      scope = scope.where(date_sold: nil) unless sold_value
    end

    # Sorting
    if @params[:sort].present? && SORT_OPTIONS.key?(@params[:sort])
      scope = scope.order(SORT_OPTIONS[@params[:sort]])
    else
      scope = scope.order(created_at: :desc) # default
    end

    scope
  end
end
