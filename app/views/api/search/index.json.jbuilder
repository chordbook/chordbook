json.array! @results do |result|
  json.id ShortIdentifier.generate(result.type, result.id)
  json.merge! result.slice(:type, :title, :subtitle, :thumbnail)
end
