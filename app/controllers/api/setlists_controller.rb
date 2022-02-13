class Api::SetlistsController < ApiController
  before_action :find_setlist, only: [:show, :destroy, :add, :remove]

  def index
    @setlists = current_scope.order_by_recent.page(params[:page])
    set_pagination_header @setlists
  end

  def show
  end

  def create
    @setlist = Setlist.new(params.require(:setlist).permit(:title, :description))
    @setlist.save!
    render :show
  end

  def destroy
    @setlist.destroy
    head :ok
  end

  def add
    @setlist.songsheets << Songsheet.find(params.dig(:songsheet, :id))
    head :created
  end

  def remove
    @songsheet = Songsheet.find(params[:songsheet_id])
    @setlist.songsheets.delete(@songsheet)
    head :ok
  end

  private

  def find_setlist
    @setlist = Setlist.find(params[:id])
  end
end
