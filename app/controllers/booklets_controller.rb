class BookletsController < ApplicationController
  before_action :set_booklet, only: [:show, :update]

  # GET /booklets
  def index
    @booklets = Booklet.all

    render json: @booklets
  end

  # GET /booklets/1
  def show
    render json: @booklet
  end

  # POST /booklets
  def create
    @booklet = Booklet.new(booklet_params)

    if @booklet.save
      render json: {success: true, details: @booklet}
    else
      render json: {success: false, details: @booklet.errors}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booklet
      @booklet = Booklet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def booklet_params
      params.require(:booklet).permit(:title, :description, :start_date, :end_date)
    end
end
