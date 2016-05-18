class User < ApplicationRecord
  VALID_USERNAME_REGEX = /\A[\w+\-.]*\z/i
  VALID_EMAIL_REGEX =     /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save :format_fields
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 50, minimum: 3 },
                    format: { with: VALID_USERNAME_REGEX },
                    uniqueness: { case_sensitive: true }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password

  def format_fields
    self.email = email.downcase 
  end
  
  def name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end
end
