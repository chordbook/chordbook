class DownloadAttachment < ApplicationJob
  include HTTParty

  queue_as :low
  raise_on 400..600

  def perform(record, attachable, src, client: DownloadAttachment)
    response = client.get(src)

    Searchkick.callbacks(false) do
      record.send(attachable).attach(
        io: StringIO.new(response.body.to_s),
        filename: File.basename(src),
        metadata: {src: src}
      )
    end
  end
end
