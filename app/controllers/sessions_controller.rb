class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:info] = "Du bist schon eingeloggt."
      redirect_to current_user
    else
      render 'new'
    end
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user&.authenticate(params[:session][:password])
  		reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  		log_in user
  		redirect_to user
		else
			if !user
				flash.now[:danger] = "E-Mail Adresse ist unbekannt."
			elsif !user.authenticate(params[:session][:password])
				flash.now[:danger] = "Password ist ungültig."
			end
			render 'new'
		end
  end

  def destroy
  	log_out if logged_in?
  	flash[:success] = "Du hast Dich erfolgreich abgemeldet."
  	redirect_to root_url
  end

end
