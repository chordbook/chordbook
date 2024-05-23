class CleanupSearchesJob < ApplicationJob
  def perform
    Searchjoy::Search.where("created_at < ?", 1.year.ago).find_in_batches do |searches|
      search_ids = searches.map(&:id)
      Searchjoy::Conversion.where(search_id: search_ids).delete_all
      Searchjoy::Search.where(id: search_ids).delete_all
    end
  end
end
