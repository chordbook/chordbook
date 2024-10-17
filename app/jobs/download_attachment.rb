class DownloadAttachment < ApplicationJob
  include HTTParty

  queue_as :low
  raise_on 400..600

  def perform(record, attachable, urls, client: DownloadAttachment)
    src = Array(urls).map(&:presence).compact.first
    attachment = record.send(attachable)

    if src && (!attachment.attached? || attachment.metadata[:src] != src)
      response = client.get(src)

      Searchkick.callbacks(false) do
        attachment.attach(
          io: StringIO.new(response.body.to_s),
          filename: File.basename(src),
          metadata: {src: src}
        )
      end
    end
  end
end
