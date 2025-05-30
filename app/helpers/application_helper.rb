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

  def description_included_url(description)
    URI.extract(description, [ "http", "https" ]).uniq.each do |url|
      link = link_to(url, url, target: "_blank", rel: "noopener", class: "text-blue-600 underline hover:text-blue-800")
      description = description.gsub(url, link)
    end

    sanitize(description)
  end
end
