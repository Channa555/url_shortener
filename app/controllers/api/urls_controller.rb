module Api
  class UrlsController < BaseController
    before_action :set_url, only: [ :show ]

    def create
      @url = Url.new(url_params)
      if @url.save
        full_short_url = "#{request.base_url}/#{@url.short_url}" # Prepend host
        render json: { short_url: full_short_url }, status: :created
      else
        render json: { errors: @url.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      render json: { original_url: @url.original_url }
    end

    private

    def set_url
      short_url = params[:short_url].split("/").last if params[:short_url].present?
      @url = Url.find_by(short_url: short_url) if short_url.present?
      head :not_found unless @url
    end

    def url_params
      params.require(:url).permit(:original_url)
    end
  end
end
