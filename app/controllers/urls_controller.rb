class UrlsController < ActionController::Base
  before_action :set_url, only: [ :show ]

  def new
    @url = Url.new
    # Instead of v1 we can use below format to support both
    # respond_to do |format|
    #   format.html  # This will look for 'new.html.erb'
    #   format.json  # You can add a JSON response if needed
    # end
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
    if params[:short_url].present?
      redirect_to @url.original_url, allow_other_host: true if @url.present? && @url.original_url.present?
    else
      render json: { url: Url.all  }
    end
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
