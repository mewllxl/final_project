class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy # เพิ่มความสัมพันธ์กับ Like
  has_many :liked_users, through: :likes, source: :user # ผู้ใช้ที่ไลค์โพสต์นี้

  validates :title, presence: true
  validates :content, presence: true

  # เพิ่มไลค์
  def like
    increment!(:likes_count)
  end
end
