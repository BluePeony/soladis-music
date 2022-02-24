class TracksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :destroy]
  before_action :get_user, only: [:new, :create, :edit, :update, :destroy, :index]
  before_action :about_track, only: [:edit, :update, :show, :destroy]
  before_action :force_json, only: :search

  def home

    @chosen_tracks = Track.all.sample(4)
  end

  def new
    @track = @user.tracks.build
  end

  def create
    @track = @user.tracks.build(track_params)
    @track.image.attach(params[:track][:image])
    @track.audio.attach(params[:track][:audio])
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
    @cat_parent = Category.find_by(id: @track.category_id).parent
    @cat = Category.find_by(id: @track.category_id)
  end

  def index

    if Track.all.size == 0
      flash[:danger] = "No tracks exist yet."
      redirect_to new_track_path
    end

    # show all published tracks    
    if (params[:published] == '1') && (params[:unpublished] == '0') 
      @tracks = Track.where(published_status: true)

    # show all unpublished tracks
    elsif (params[:published] == '0') && (params[:unpublished] == '1')
      @tracks = Track.where(published_status: false)

      # for non-admins show only their own unpublished tracks
      if !super_admin_user?(@user)
        @tracks = @tracks.where("user_id=?", @user.id)
      end

    # for non-admins show all published and all own tracks
    # for admins show all tracks
    else
      if !super_admin_user?(@user)
        @tracks = Track.where(published_status: true).or(Track.where("user_id=?", @user.id))
      else
        @tracks = Track.all
      end
    end

    # add pagination
    @tracks = @tracks.paginate(page: params[:page])
  end

  def destroy
    title = @track.title    
    if @track.destroy
      flash[:success] = "Track '#{title}' gelöscht."
      redirect_to tracks_path
    end  
  end

  def all_tracks

    # show all published tracks
    if params[:category_id].blank? 
      @tracks = Track.where(published_status: true)
    else
      @category = Category.find_by(id: params[:category_id])

      # show tracks in the chosen subcategory
      if @category.has_parent? 
        @tracks = Track.where(published_status: true, category_id: params[:category_id])

      # show tracks in the chosen main category  
      else 
        @tracks = Track.where(published_status: true, category_id: @category.child_ids)
      end
    end

  end

  def search
    t = params[:t].downcase
    @tracks = Track.where("title LIKE ?", "%#{t}%")
  end

  private

    def track_params
      params.require(:track).permit(:title, :description, :item_number, :composer, :category_id, :published_status, :image, :audio)
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
          action = "Löschung des Tracks"
        end

        if ((@track.user_id != @user.id) && !super_admin_user?(@user)) # Autor || Admin || Superadmin
          flash[:danger] = "Du hast keine Berechtigung für #{action}"
          redirect_to root_url
        end
        
      end

    end

    def force_json
      request.format = :json
    end
end
