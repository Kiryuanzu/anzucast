class Episode < ApplicationRecord
  belongs_to :user

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
