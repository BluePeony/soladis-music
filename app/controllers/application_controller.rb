class ApplicationController < ActionController::Base

	include SessionsHelper
	
	def home
	end
	
	private
	
		# controllers/application_controller.rb
		# Confirms a logged-in user.
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Bitte logge Dich ein!"
				redirect_to login_url
			end
		end

end
