json.array! @results do |result|
  json.merge! result.slice(:id, :type, :title, :subtitle, :thumbnail)
end
