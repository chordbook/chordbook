class Api::LibraryController < ApiController
  def create
    item = current_user.library.add(record)
    if item.valid?
      head :created
    else
      render_error record: item
    end
  end

  def show
    current_user.library.find_by!(item: record)
    head :ok
  end

  def destroy
    current_user.library.find_by!(item: record).destroy
    head :ok
  end

  private

  def record
    ShortIdentifier.locate(params[:id])
  rescue
    nil # Rely on LibraryItem validations
  end
end
