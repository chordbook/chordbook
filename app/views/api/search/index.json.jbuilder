json.array! @results do |result|
  json.id ShortIdentifier.generate(result.type, result.id)
  json.merge! result.slice(:type, :title, :subtitle)
  json.thumbnail result[:attachment_id] ? variant_url(@attachments[result[:attachment_id]], :track) : result[:thumbnail]
end
