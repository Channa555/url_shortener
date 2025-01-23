class UrlsController < ApplicationController
  before_action :set_url, only: [ :show ]

  def new
    @url = Url.new
    # render :new
    respond_to do |format|
      format.html  # This will look for 'new.html.erb'
      format.json  # You can add a JSON response if needed
    end
  end

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
    render json: { urls: Url.all }
  end

  private

  def set_url
    @url = Url.find_by(short_url: params[:short_url])
    # head :not_found unless @url
  end

  #  Using strong parameters concept to allow only required param
  def url_params
    params.require(:url).permit(:original_url)
  end
end
