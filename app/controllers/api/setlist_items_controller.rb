class Api::SetlistItemsController < ApiController
  before_action :find_setlist, except: :index
  before_action :find_item, only: [:update, :destroy]

  def create
    songsheet = Songsheet.find_by_uid(params[:id])
    current_scope.create!(songsheet: songsheet)
    current_user.library.add(songsheet)
    head :created
  end

  def update
    @item.update! item_params
    head :ok
  end

  def destroy
    @item.destroy
    head :ok
  end

  private

  def item_params
    params.require(:item).permit(:position)
  end

  def find_setlist
    @setlist = current_user!.owned_setlists.find_by_uid(params[:setlist_id])
  end

  def current_scope
    @setlist.items.includes(:songsheet)
  end

  def find_item
    @songsheet = Songsheet.find_by_uid(params[:id])
    @item = current_scope.find_by!(songsheet: @songsheet)
  end
end
