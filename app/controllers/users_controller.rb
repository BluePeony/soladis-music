class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :show, :index, :destroy]
	before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user?, only: [:destroy]

  def new
  	@user = User.new
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

  def show
    @user = User.find(params[:id])
    @tracks = @user.tracks.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def edit
  	@user = User.find_by(id: params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Dein Profil wurde erfolgreich aktualisiert."
      redirect_to @user
    else
      render 'edit'
    end  	
  end

  def index
  	@users = User.where(activated: true).paginate(page: params[:page])
  end

  def destroy
    user = User.find(params[:id])
    if user.id != 1
      if user.tracks.size != 0
        user.tracks.each do |track|
          track.user_id = 1
          track.save
        end
      end
      user.destroy
      flash[:success] = "User wurde gelöscht"
      redirect_back(fallback_location: root_url)
    else
      flash[:danger] = "User ist Superadmin. Superadmin darf nicht gelöscht werden."
      redirect_to user_url
    end 
  	
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  	end

  	# Before filter

  	# Confirms the correct user
  	def correct_user
  		@user = User.find(params[:id])
      if current_user == @user || admin_user?
        return true
      else
        flash[:danger] = "Du hast keine Berechtigung für diese Seite. Weiterleitung zur Homepage"
        redirect_to root_url
      end
      #return false unless (current_user == @user || admin_user?)
  	end

  	# Confirms that the user is admin
  	def admin_user?
  		is_admin = false
  		if (current_user.admin? || current_user.superadmin?)
  			is_admin = true
  		else
  			is_admin = false
  		end
  		return is_admin
  	end
end
