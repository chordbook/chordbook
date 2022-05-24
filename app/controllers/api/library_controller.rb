class Api::LibraryController < ApiController
  def create
    item = current_user.library_items.build(item: record)
    if item.save
      head :created
    else
      render_error record: item
    end
  end

  def show
    current_user.library_items.find_by!(item: record)
    head :ok
  end

  def destroy
    current_user.library_items.find_by!(item: record).destroy
    head :ok
  end

  private

  def record
    ApplicationRecord.locate(params[:uid])
  rescue
    nil # Rely on LibraryItem validations
  end
end
