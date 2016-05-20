class AccountActivationCode < ApplicationRecord
	belongs_to :user
  	validates :code, presence: true, length: { minimum: 10 }
end
