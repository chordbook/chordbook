class Api::SetlistsController < ApiController
  def index
    @setlists = current_scope.page(params[:page])
    set_pagination_header @setlists
  end

  def show
    @setlist = Setlist.find(params[:id])
  end

  def add
    @setlist = Setlist.find(params[:id])
    @setlist.songsheets << Songsheet.find(params.dig(:songsheet, :id))
    head :created
  end
end
