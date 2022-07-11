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
    }
  }

  def variant_url(attachment, variant)
    rails_blob_url(attachment.variant(VARIANTS[variant]))
  end
end
