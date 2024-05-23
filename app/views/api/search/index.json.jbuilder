json.array! @results do |result|
  uid = ShortIdentifier.generate(result.type, result.id)
  json.id uid
  json.merge! result.slice(:type, :title, :subtitle)

  attachment = @attachments[result[:attachment_id]]
  json.thumbnail variant_url(attachment, :small) if attachment
  json.convert_url api_convert_search_url(@results.search.id, uid)
end
