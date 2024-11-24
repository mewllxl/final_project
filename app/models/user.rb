class User < ApplicationRecord
    has_secure_password
    has_many :posts, dependent: :destroy
    has_many :likes, dependent: :destroy # ความสัมพันธ์กับ Like
    has_many :liked_posts, through: :likes, source: :post # โพสต์ที่ผู้ใช้ไลค์
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }

    def liked?(post)
        liked_posts.include?(post)
    end
  end
  