class User < ApplicationRecord
	attr_accessor :remember_token

	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

	has_secure_password
	validates :password, presence: true, length: { minimum: 8 }

	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(self.remember_token))
		remember_digest
	end

	# Returns a session token to prevent session hijacking.
	# We reuse the remember digest for convenience.
	def session_token
		remember_digest || remember
	end

	# Returns the hash digest of the given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Returns true if the user is authenticated - if the remember token corresponds to the remember digest
	def authenticated?(remember_token)
		if remember_digest
			BCrypt::Password.new(remember_digest).is_password?(remember_token)
		else
			return false
		end
	end

	# Forgets a user
	def forget
		update_attribute(:remember_digest, nil)
	end
end
