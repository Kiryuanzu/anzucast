module ApplicationHelper
  def cloudfront_audio_file_url(attachment)
    return nil unless attachment.attached?

    "https://#{ENV['AWS_CLOUD_FRONT_DOMAIN']}/#{attachment.key}"
  end

  def cloudfront_cover_image_url(attachment)
    case attachment
    when ActiveStorage::Variant, ActiveStorage::VariantWithRecord
      attachment.processed.key
    when ActiveStorage::Attached::One, ActiveStorage::Blob
      attachment.try(:blob)&.key || attachment.key
    else
      nil
    end
    "https://#{ENV['AWS_CLOUD_FRONT_DOMAIN']}/#{attachment.key}"
  end
end
