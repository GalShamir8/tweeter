class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    validates_presence_of :username
    validates_presence_of :password
    validates_format_of :password, :with => /[a-z0-9]{6,20}/
    
  has_many :tweets
  has_many :followers
end
