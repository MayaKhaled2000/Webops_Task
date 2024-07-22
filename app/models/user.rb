class User < ApplicationRecord
    has_secure_password
  
    has_one_attached :image
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
  end