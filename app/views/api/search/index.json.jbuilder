json.array! @results do |result|
  json.merge! id: result.searchable_id, type: result.searchable_type, rank: result.pg_search_rank
  json.merge! result.data
end
