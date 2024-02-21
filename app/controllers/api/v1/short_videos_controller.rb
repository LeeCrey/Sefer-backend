# frozen_string_literal: true

class Api::V1::ShortVideosController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_video, only: %i[update destroy vote]
  before_action :authorize_user, only: %i[update destroy]

  # GET /api/v1/short_videos
  def index
    @meta, @videos = pagy(ShortVideo.includes(:user).all)
  end

  # POST /api/v1/short_videos
  def create
    @video = current_user.short_videos.new(video_params)

    render_model_errors(@video) unless @video.save
  end

  # PATCH /api/v1/short_videos/:id
  def update
    if @video.update(update_params)
      render_success(I18n.t('updated', resource: 'Post'))
    else
      render_model_errors(@video)
    end
  end

  # DELETE /api/v1/short_videos/:id
  def destroy
    @video.destroy!
  end

  # POST /api/v1/short_videos/:id/vote
  def vote
    @voted = current_user.voted_for? @video
    if @voted
      @video.unliked_by current_user
    else
      @video.liked_by current_user
    end

    render :vote, formats: :json
  end

  private

  def authorize_user
    authorize @video
  end

  def set_video
    @video = ShortVideo.find_by(id: params[:id])

    raise_if_blank(@video, 'Video')
  end

  def video_params
    params.require(:short_video).permit(:caption, :video)
  end

  def update_params
    params.require(:short_video).permit(:caption)
  end
end
