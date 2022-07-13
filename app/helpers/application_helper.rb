module ApplicationHelper
  VARIANTS = {
    track: {
      resize_to_fill: [72, 72], format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 80}
    },
    thumb: {
      resize_to_fill: [400, 400], format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
    },
    genre: {
      resize_to_fill: [500, 375], format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
    },
    banner: {
      resize_to_fit: [1280, 720], format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
    }
  }

  def variant_url(attachment, variant_name)
    variant = attachment.variant(VARIANTS[variant_name])
    if variant.processed? && variant.service.public?
      # Variant is processed and public, link directly to it.
      variant.url
    else
      # Variant needs processed or is not public, so let ActiveStorage do its thing
      rails_blob_url(variant)
    end
  end
end
