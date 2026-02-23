class ApplicationController < ActionController::API
    include ErrorHandler
    include Pagy::Backend
    include Pagy::Frontend
end
