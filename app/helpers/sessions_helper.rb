module SessionsHelper

	# Logs in the given user
	def log_in(user)
		session[:user_id] = user.id
		# Guard against session replay attacks.
		session[:session_token] = user.session_token
	end

	# Remembers a user in a persistent session
	def remember(user)
		user.remember
		cookies.permanent.encrypted[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Forgets a user in a pesistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Returns the current logged-in user (if any)
	def current_user
	  if (user_id = session[:user_id])
	  	user = User.find_by(id: user_id)
	  	if user && (session[:session_token] == user.session_token)
	  		@current_user = user
	  	end
	    #@current_user ||= User.find_by(id: user_id)
	  elsif (user_id = cookies.encrypted[:user_id])
	    user = User.find_by(id: user_id)
	    if user && user.authenticated?(:remember, cookies[:remember_token])
	      log_in user
	      @current_user = user
	    end
	  end
	end

	# Returns true if the given user is the current user.
	def current_user?(user)
		user && user == current_user
	end

	# Returns true if the user is logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end

	# helpers/sessions_helper.rb
	# Confirms a logged-in user.
	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "Bitte logge Dich ein!"
			redirect_to login_url
		end
	end


	# Logs out the current user
	def log_out
		forget(current_user)
		reset_session
		@current_user = nil
	end

	# Stores the URL trying to be accessed.
	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end

	# Checks if the User is admin or superadmin
	def super_admin_user?(user)
		user.admin? || user.superadmin? 
	end

end
