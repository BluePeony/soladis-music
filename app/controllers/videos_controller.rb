class VideosController < ApplicationController
	before_action :get_user

  def new
  	@video = @user.videos.build
  end

  def create
  	puts params
  	puts "Here"
  	track_titles = params[:video][:used_tracks].gsub(", ", ",").split(',')
  	p track_titles
  	
  	@video = @user.videos.build(video_params)
  	@video.url["watch?v="] = "embed/" if @video.url.include?("watch?v=")
  	if @video.save
  		flash.now[:success] = "Neues Video hinzugefügt"
  		track_titles.each do |tt|
  			@video.track_videos.create(track_id: Track.find_by(title: tt).id)
  		end
  		redirect_to @video
  	else
  		flash.now[:danger] = "Das Hinzufügen von Video ist fehlgeschlagen"
  		render 'new'
  	end
  end

  def show
  	@video = Video.find_by(id: params[:id])
  	if !@video
  		flash[:danger] = "Das Video existiert nicht."
  		redirect_to videos_path
  	end
  end

  def edit
  	@video = Video.find_by(id: params[:id])
  end

  def update
  end

  def index
  	@videos = Video.all
  	if @videos.size == 0
  		flash[:danger] = "Es existieren noch keine Videos"
  		redirect_to new_video_path
  	end
  end

  def destroy
  	@video = Video.find_by(id: params[:id])
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

  	def trackvideo_params
  	end

  	def get_user
  		@user = current_user
  	end
end
