class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :show, :index, :destroy]
	before_action :correct_user, only: [:edit, :update, :show]
	before_action :admin_user, only: :destroy

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	redirect_to root_url and return unless @user.activated?
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		@user.send_activation_email 
  		flash[:info] = "Wir haben Dir eine E-Mail zur Aktivierung Deines Accounts geschickt."
  		redirect_to root_url
      #reset_session
      #log_in @user
  		#flash[:success] = "Welcome to Soladis-Music!"
  		#redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  	#@user = User.find_by(id: params[:id])
  	puts "#{request.original_url}"
  	puts "#{request.path}"
  end

  def update
  	#@user = User.find_by(id: params[:id])
  	# Wenn admin-Attribut nicht verändert werden soll oder wenn der User Superadmin ist
  	if (@user.admin == user_params[:admin]) || (admin_user)
  		if @user.update(user_params)
	  		flash[:success] = "Dein Profil wurde erfolgreich aktualisiert."
	  		redirect_to @user
	  	else
	  		render 'edit'
	  	end
  	end  	
  end

  def index
  	@users = User.where(activated: true).paginate(page: params[:page])
  end

  def destroy
  	User.find(params[:id]).destroy 
  	flash[:success] = "User wurde gelöscht"
  	redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  	end

  	# Before filter

  	# Confirms a logged-in user.
  	def logged_in_user
  		unless logged_in?
  			store_location
  			flash[:danger] = "Bitte logge Dich ein!"
  			redirect_to login_url
  		end
  	end

  	# Confirms the correct user
  	def correct_user
  		@user = User.find(params[:id])
  		if !admin_user && !current_user?(@user)
				flash[:danger] = "Du hast keine Berechtigung, auf die Profile anderer User zuzugreifen."
				redirect_to root_url
  		end
  	end

  	# Confirms that the user is admin
  	def admin_user
  		is_admin = false
  		if (current_user.admin? || current_user.superadmin?)
  			is_admin = true
  		else
  			redirect_to(root_url)
  			is_admin = false
  		end
  		return is_admin
  	end
end
