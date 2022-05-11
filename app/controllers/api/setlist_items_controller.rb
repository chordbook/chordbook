class Api::SetlistItemsController < ApiController
  before_action :find_setlist

  def index
    @items = current_scope.page(params[:page])
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
    @setlist = Setlist.find(params[:setlist_id])
  end

  def current_scope
    @setlist.items.includes(:songsheet)
  end
end
