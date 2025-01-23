module Api
  class BaseController < ActionController::API
    before_action :authenticate_request

    private

    def authenticate_request
      token = request.headers["Authorization"]&.split(" ")&.last
      head :unauthorized unless ApiToken.exists?(token: token)
    end
  end
end
