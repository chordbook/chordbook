module AttachmentFromUrl
  include HTTParty
  raise_on 400..600

  def from_url(url, metadata: {}, client: AttachmentFromUrl, headers: {})
    response = client.get(url, headers: headers)

    attach(
      io: StringIO.new(response.body.to_s),
      filename: File.basename(url),
      metadata: metadata.merge({src: url})
    )
  end
end

Rails.configuration.to_prepare do
  ActiveStorage::Attached::Many.include AttachmentFromUrl
  ActiveStorage::Attached::One.include AttachmentFromUrl
end
