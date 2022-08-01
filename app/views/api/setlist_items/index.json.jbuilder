json.array! @items.map(&:songsheet), partial: "api/songsheets/songsheet", as: :songsheet
