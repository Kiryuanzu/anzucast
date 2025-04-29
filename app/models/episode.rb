class Episode < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true
  validates :published_at, presence: true
  validates :guid, presence: true, uniqueness: true
end
