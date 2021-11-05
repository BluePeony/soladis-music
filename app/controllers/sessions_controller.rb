class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user&.authenticate(params[:session][:password])
  		reset_session
  		log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
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
