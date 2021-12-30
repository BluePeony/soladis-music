class TracksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :destroy]
  before_action :get_user
  before_action :about_track, only: [:edit, :update, :show, :destroy]

  def new
    @track = @user.tracks.build
  end

  def create
    @track = @user.tracks.build(track_params)
    @track.image.attach(params[:track][:image])
    if @track.save
      if @track.published_status
        @track.update_attribute(:published_at, Time.zone.now)
      end
      flash[:success] = "Neuer Track wurde erstellt"
      redirect_to @track
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @track.update(track_params)
      flash[:success] = "Deine Änderungen wurden gespeichert."
      redirect_to @track
    else
      flash.now[:danger] = "Deine Änderungen wurden nicht gespeichert."
      render 'edit'
    end
  end

  def show
    puts params[:action]
  end

  def index
    @tracks = Track.all.paginate(page: params[:page])
    if @tracks.size == 0
      flash[:danger] = "Es existieren noch keine Tracks"
      redirect_to new_track_path
    end

  end

  def destroy    
    if @track.destroy
      flash[:success] = "Track #{@track.title} gelöscht."
      redirect_back(fallback_location: root_url)
    end  
  end

  private

    def track_params
      params.require(:track).permit(:title, :description, :item_number, :composer, :published_status, :image)
    end

    def get_user
      @user = current_user
    end

    def about_track
      @track = Track.find_by(id: params[:id])

      if !@track
        flash[:danger] = "Der gesuchte Track existiert nicht."
        redirect_to root_url
      end

      if "edit_update_destroy".include?(params[:action])
        
        if params[:action] == 'edit'
          action = "Bearbeitung von #{@track.title}"
        elsif params[:action] == 'update'
          action = "Speicherung der Änderungen für #{@track.title}"
        elsif params[:action] == 'destroy'
          action = "Löschung des #{@track.title}"
        end

        if ((@track.user_id != @user.id) && !super_admin_user?(@user)) # Autor || Admin || Superadmin
          flash[:danger] = "Du hast keine Berechtigung für #{action}"
          redirect_to root_url
        end
        
      end

    end
end