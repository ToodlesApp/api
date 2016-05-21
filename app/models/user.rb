class User < ApplicationRecord
  VALID_USERNAME_REGEX = /\A[\w+\-.]*\z/i
  VALID_EMAIL_REGEX =     /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save :format_fields
  after_create :create_activation_code

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

  has_one :account_activation_code

  def is_activated
    return self.account_activation_code == nil
  end

  def activate(code)
    if self.account_activation_code.code == code
      return self.account_activation_code.destroy
    else
      return false
    end
  end

  def format_fields
    self.email = email.downcase 
  end
  
  def name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end

  def create_activation_code
    AccountActivationCode.new(user_id: self.id, code: SecureRandom.uuid).save
  end
end
