class Episode < ApplicationRecord
  belongs_to :user

  has_one_attached :cover_image
  has_one_attached :audio_file

  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true
  validates :published_at, presence: true
  validates :guid, presence: true, uniqueness: true

  before_validation :set_guid, on: :create

  private

  def set_guid
    self.guid ||= SecureRandom.uuid
  end
end
