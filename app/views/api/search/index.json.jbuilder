json.array! @results do |result|
  json.id ShortIdentifier.generate(result.type, result.id)
  json.merge! result.slice(:type, :title, :subtitle)

  attachment = @attachments[result[:attachment_id]]
  json.thumbnail variant_url(attachment, :small) if attachment
end
