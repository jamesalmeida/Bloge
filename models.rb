class User < ActiveRecord::Base
	
	def full_name
		if fname && lname
			fname + ' ' + lname
		elsif fname
			fname
		elsif lname
			lname
		else
			nil
		end
	end

	attr_accessor :password

	before_save :encrypt_password

	def encrypt_password
		if self.password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	def self.authenticate(username, password)
		user = User.where(username: username).first
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	has_many :posts
end

class Post < ActiveRecord::Base
	belongs_to :user
end


