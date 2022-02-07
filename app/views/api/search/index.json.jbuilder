json.array! @results do |result|
  json.merge! id: result.searchable_id, type: result.searchable_type
  json.merge! result.data
end
