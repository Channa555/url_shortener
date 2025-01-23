module Api
  class ApiTokensController < BaseController
    skip_before_action :authenticate_request, only: [ :create ]

    def create
      api_token = ApiToken.create!(token: SecureRandom.hex(16))
      render json: { token: api_token.token }, status: :created
    end
  end
end
