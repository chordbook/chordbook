class GeneratedSetlists < ApplicationJob
  def perform
    Trending.perform_later
    WhatsNew.perform_later
    RecentlyUpdated.perform_later
    Favorites.perform_later
    Decades.perform_later
    Unmatched.perform_later
    TooManyVersions.perform_later
    KeyOf.perform_later
  end

  def update_setlist(title, attrs: nil, &scope)
    Setlist.transaction do
      setlist = User.app.owned_setlists.find_or_create_by!(title: title) do |s|
        s.assign_attributes attrs if attrs
      end
      setlist.items.clear
      setlist.songsheets = scope.call.limit(100)
    end
  end
end
