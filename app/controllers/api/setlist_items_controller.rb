class Api::SetlistItemsController < ApiController
  before_action :find_setlist, except: :index

  def index
    @items = Setlist.find(params[:setlist_id]).items.includes(:songsheet).page(params[:page])
    set_pagination_header @items
    fresh_when @items
  end

  def create
    current_scope.create!(item_params)
    head :created
  end

  def update
    @item = current_scope.find_by!(songsheet_id: params[:id])
    @item.update! item_params
    head :ok
  end

  def destroy
    @item = current_scope.find_by!(songsheet_id: params[:id])
    @item.destroy
    head :ok
  end

  private

  def item_params
    params.require(:item).permit(:songsheet_id, :position)
  end

  def find_setlist
    @setlist = current_user!.owned_setlists.find(params[:setlist_id])
  end

  def current_scope
    @setlist.items.includes(:songsheet)
  end
end
