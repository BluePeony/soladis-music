class VideosController < ApplicationController
	before_action :get_user, only: [:new, :create, :edit, :update, :destroy]
	before_action :about_video, only: [:show, :edit, :update, :destroy]

  def new
  	@video = @user.videos.build
  end

  def create
  	track_titles = params[:video][:used_tracks].gsub(", ", ",").split(',')
  	
  	@video = @user.videos.build(video_params)
  	@video.url["watch?v="] = "embed/" if @video.url.include?("watch?v=")
  	if @video.save
  		flash.now[:success] = "Neues Video hinzugefügt"
  		track_titles.each do |tt|
  			@video.track_videos.create(track_id: Track.find_by(title: tt).id)
  		end
  		redirect_to videos_path
  	else
  		flash.now[:danger] = "Das Hinzufügen von Video ist fehlgeschlagen"
  		render 'new'
  	end
  end

  def show
  end

  def edit
  end

  def update
  	existing_used_tracks = @video.used_tracks.split(', ')
  	new_used_tracks = params[:video][:used_tracks].split(', ')
  	track_videos_to_delete = existing_used_tracks - new_used_tracks
  	track_videos_to_create = new_used_tracks - existing_used_tracks
  	if @video.update(video_params)
  		flash[:success] = "Die Änderungen wurden gespeichert."
  		if track_videos_to_delete != [] # Track-Verbindungen, die zu löschen sind
  			track_videos_to_delete.each do |t|
  				t = Track.find_by(title: t)
  				@video.track_videos.find_by(track_id: t.id).destroy
  			end
  		end

  		if track_videos_to_create != [] # Verbindungen, die zu erzeugen sind
  			track_videos_to_create.each do |t|
  				t = Track.find_by(title: t)
  				@video.track_videos.create(track_id: t.id)
  			end
  		end
  		redirect_to videos_path
  	else
  		flash[:danger] = "Das Video konnte nicht gespeichert werden."
  		redirect_to videos_path
  	end
  end

  def index
  	@videos = Video.all
  	if @videos.size == 0
  		flash[:danger] = "Es existieren noch keine Videos"
  		redirect_to new_video_path
  	end
  end

  def destroy
	  TrackVideo.where(video_id: @video.id).each { |tv| tv.destroy }
	  if @video.destroy
			flash[:success] = "Video wurde gelöscht."
		else
			flash[:danger] = "Das Löschen von Video schlug fehl."
		end  		

  	redirect_to videos_path

  end

  private

  	def video_params
  		params.require(:video).permit(:url, :used_tracks)
  	end

  	def get_user
  		if current_user == nil
  			store_location
  			flash[:info] = "Bitte logge Dich zuerst ein!"
  			redirect_to login_path
  		else
  			@user = current_user
  		end
  	end

  	def about_video
  		@video = Video.find_by(id: params[:id])
  		if !@video
  			flash[:danger] = "Das Video existiert nicht."
  			redirect_to videos_path
  		else # Video existiert
  			if request.path == edit_video_path(@video) || params[:action] == 'destroy'
					if !(@user.id == @video.user_id || super_admin_user?(@user))
  	  			flash[:danger] = "Du hast keine Berechtigung für diese Aktion."
  					redirect_to videos_path
  				end
  			end
  		end

  	end
end
