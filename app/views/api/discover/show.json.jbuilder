json.setlists do
  json.array! @setlists, partial: "api/setlists/setlist", as: :setlist
end
