class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		reset_session
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
  end
end
