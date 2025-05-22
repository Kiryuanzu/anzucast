class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def attachable_storage_path
    raise NotImplementedError
  end

  # attachmendt.key を拡張子つきで生成するためにオーバーライドする
  def create_blob(attachment)
    return if attachment.nil?

    ActiveStorage::Blob.new.tap do |blob|
      blob.filename = attachment.original_filename
      blob.key = attachable_storage_path
      blob.content_type = attachment.content_type
      blob.upload(attachment, identify: false)
      blob.save!
    end
  end
end
