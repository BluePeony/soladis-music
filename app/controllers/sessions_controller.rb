class SessionsController < ApplicationController

  # Checks if login is necessary
  def new
    if logged_in?
      flash[:info] = "Du bist schon eingeloggt."
      redirect_to current_user
    else
      render 'new'
    end
  end

  # Creates new session
  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        message = "Account nicht aktiviert. "
        message += "Schaue in Deinen E-Mails nach dem Aktivierungslink."
        flash[:warning] = message
        redirect_to root_url
      end      
		else
			if !user
				flash.now[:danger] = "E-Mail Adresse ist unbekannt."
			elsif !user.authenticate(params[:session][:password])
				flash.now[:danger] = "Password ist ungültig."
			end
			render 'new'
		end
  end

  # Destroy current session - logs out the user
  def destroy
  	log_out if logged_in?
  	flash[:success] = "Du hast Dich erfolgreich abgemeldet."
  	redirect_to "https://soladis-music.net"
  end

end
