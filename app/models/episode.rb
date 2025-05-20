class Episode < ApplicationRecord
  belongs_to :user

  has_one_attached :cover_image
  has_one_attached :audio_file

  validate :check_file_content_type

  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true
  validates :published_at, presence: true
  validates :guid, presence: true, uniqueness: true
  validates :cover_image, presence: true
  validates :audio_file, presence: true



  before_validation :set_guid, on: :create

  private

  def set_guid
    self.guid ||= SecureRandom.uuid
  end

  def check_file_content_type
    if cover_image.attached? && !cover_image.content_type.in?(%w[image/png image/jpeg])
      errors.add(:cover_image, "は PNG, JPEG形式のみ対応しています")
    end

    if audio_file.attached? && !audio_file.content_type.in?(%w[audio/mpeg audio/mp3 audio/mp4 audio/x-m4a])
      errors.add(:audio_file, "は MP3, M4A形式のみ対応しています")
    end
  end
end
