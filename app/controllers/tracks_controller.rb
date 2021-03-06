class TracksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :destroy]  # logged_in_user method defined in app/helpers/sessions_helpers.rb
  before_action :get_user, only: [:new, :create, :edit, :update, :index, :destroy] # get_user method defined in /app/heplers/sessions_helper.rb
  before_action :about_track, only: [:edit, :update, :show, :destroy]
  before_action :force_json, only: :search

  # Randomly chooses 4 tracks to display on the homepage
  def home
    @chosen_tracks = Track.all.sample(4)
  end

  def new
    @track = @user.tracks.build
  end

  # Creates a new track
  def create
    @track = @user.tracks.build(track_params)
    @track.image.attach(params[:track][:image])
    @track.audio.attach(params[:track][:audio])
    if @track.save
      if @track.published_status
        @track.update_attribute(:published_at, Time.zone.now)
      end
      flash[:success] = "Neuer Track wurde erstellt" # success message: New track has been created
      redirect_to @track
    else
      render 'new'
    end
  end

  def edit
  end

  # Updates a track
  def update
    if @track.update(track_params)
      flash[:success] = "Deine Änderungen wurden gespeichert." # success messages: Your changes have been saved.
      redirect_to @track
    else
      flash.now[:danger] = "Deine Änderungen wurden nicht gespeichert." # failure message: Your changes have not been saved.
      render 'edit'
    end
  end

  # Shows a track
  def show
    @cat_parent = Category.find_by(id: @track.category_id).parent
    @cat = Category.find_by(id: @track.category_id)
  end

  # Shows all tracks, according to the chosen filter option
  def index
    if Track.all.size == 0
      flash[:danger] = "No tracks exist yet."
      redirect_to new_track_path
    end

    # Shows all published tracks    
    if (params[:published] == '1') && (params[:unpublished] == '0') 
      @tracks = Track.where(published_status: true)

    # Shows all unpublished tracks
    elsif (params[:published] == '0') && (params[:unpublished] == '1')
      @tracks = Track.where(published_status: false)

      # For non-admins show only their own unpublished tracks
      if !super_admin_user?(@user)
        @tracks = @tracks.where("user_id=?", @user.id)
      end

    # For non-admins show all published and all own unpublished tracks
    # For admins show all tracks
    else
      if !super_admin_user?(@user)
        @tracks = Track.where(published_status: true).or(Track.where("user_id=?", @user.id))
      else
        @tracks = Track.all
      end
    end

    # Adds pagination
    @tracks = @tracks.paginate(page: params[:page])
  end


  # Destroys a track
  def destroy
    title = @track.title    
    if @track.destroy
      flash[:success] = "Track '#{title}' gelöscht." # success message: Track destroyed.
      redirect_to tracks_path
    end  
  end

  # Shows all published tracks according to the chosen category
  def music

    # Show all published tracks
    if params[:category_id].blank? 
      @tracks = Track.where(published_status: true)
    else
      @category = Category.find_by(id: params[:category_id])

      # Show tracks in the chosen subcategory
      if @category.has_parent? 
        @tracks = Track.where(published_status: true, category_id: params[:category_id])

      # Show tracks in the chosen main category  
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

    # Declares which track attributes may be modified through the web
    def track_params
      params.require(:track).permit(:title, :description, :item_number, :composer, :category_id, :published_status, :image, :audio)
    end


    # Gets information about a track
    def about_track
      @track = Track.find_by(id: params[:id])

      if !@track
        flash[:danger] = "Der gesuchte Track existiert nicht." # failure message: The requested track does not exist.
        redirect_to root_url
      end

      # Prepares flash messages for different actions
      if "edit_update_destroy".include?(params[:action])
        
        if params[:action] == 'edit'
          action = "Bearbeitung von #{@track.title}" # action = "Editing of ..."
        elsif params[:action] == 'update'
          action = "Speicherung der Änderungen für #{@track.title}" # action = "Saving of changes for ..."
        elsif params[:action] == 'destroy'
          action = "Löschung des Tracks" # action = "Deleting of track"
        end

        # If the logged in user is neither the author of the track nor admin/superadmin
        if ((@track.user_id != @user.id) && !super_admin_user?(@user)) 
          flash[:danger] = "Du hast keine Berechtigung für #{action}" # failure message: You don't have the persmission for ...
          redirect_to root_url
        end
        
      end

    end

    def force_json
      request.format = :json
    end
end
