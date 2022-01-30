class User < ApplicationRecord
    validates_presence_of :username
    validates_presence_of :password
    validates_format_of :password, :with => /[a-z0-9]{6,20}/
end
