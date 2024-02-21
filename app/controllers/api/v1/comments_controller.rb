# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_commentable, only: %i[index create]
  before_action :set_comment, only: %i[show update destroy vote]
  before_action :authorize_comment, except: %i[index create]
  before_action :authorize_commentable, only: %i[index create]

  # GET /api/v1/:commentable_type/:commentable_id/comments
  def index
    @meta, @comments = pagy(@commentable.comments.includes(:user).order(id: :desc))
  end

  # GET /api/v1/comments/1
  # GET /api/v1/comments/1.json
  def show
  end

  # POST  /api/v1/posts/:post_id/comments
  # POST  /api/v1/posts/:post_id/comments.json
  def create
    @comment = @commentable.comments.new(comments_params)
    @comment.user_id = current_user.id

    render_model_errors(@comment) unless @comment.save
  end

  # PATCH/PUT /api/v1/comments/1
  # PATCH/PUT /api/v1/comments/1.json
  def update
    if @comment.update(comment_params)
      render_success(I18n.t('updated', resource: 'Comment'))
    else
      render_model_errors(@comment)
    end
  end

  # DELETE /api/v1/comments/1
  # DELETE /api/v1/comments/1.json
  def destroy
    @comment.destroy!
  end

  # POST api/v1/comments/:id/vote
  def vote
    @voted = current_user.voted_for? @comment
    if @voted
      @comment.unliked_by current_user
    else
      @comment.liked_by current_user
    end

    render :vote, formats: :json
  end

  private

  def authorize_commentable
    authorize @commentable
  end

  def authorize_comment
    authorize @comment
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])

    raise_if_blank(@comment, 'Comment')
  end

  def set_commentable
    # possible commentable_types(post, short_videos), for now!
    @commentable = if params[:commentable_type] == 'posts'
                     Post.find_by(id: params[:commentable_id])
                   else
                     ShortVideo.find_by(id: params[:commentable_id])
                   end

    raise_if_blank(@commentable, params[:commentable_type])
  end

  def comments_params
    params.require(:comment).permit(:content)
  end
end
