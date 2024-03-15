module ApplicationHelper
  def variant_url(attachment, variant_name)
    return unless attachment&.variable?

    variant = attachment.variant(variant_name)
    if variant.send(:processed?) && variant.service.public?
      # Variant is processed and public, link directly to it.
      variant.url
    else
      # Variant needs processed or is not public, so let ActiveStorage do its thing
      rails_blob_url(variant)
    end
  end
end
