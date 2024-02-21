# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_post, only: %i[show update destroy vote users]
  before_action :authorize_user, except: %i[index create search liked]

  # GET /api/v1/posts
  # GET /api/v1/posts.json
  def index
    @meta, @posts = pagy(Post.following_users_post(current_user.id))
  end

  # GET /api/v1/posts/1
  # GET /api/v1/posts/1.json
  def show
  end

  # POST /api/v1/posts
  # POST /api/v1/posts.json
  def create
    @post = current_user.posts.new(posts_params)

    render_model_errors(@post) unless @post.save
  end

  # PATCH/PUT /api/v1/posts/1
  # PATCH/PUT /api/v1/posts/1.json
  def update
    if @post.update(posts_params)
      render_success(I18n.t('updated', resource: 'Post'))
    else
      render_model_errors(@post)
    end
  end

  # DELETE /api/v1/posts/1
  # DELETE /api/v1/posts/1.json
  def destroy
    @post.destroy!
  end

  # POST /api/v1/posts/:id/vote
  # POST /api/v1/posts/:id/vote.json
  def vote
    @voted = current_user.voted_for? @post
    if @voted
      @post.unliked_by current_user
    else
      @post.liked_by current_user
    end

    render :vote, formats: :json
  end

  # GET /api/v1/posts/search?tag
  def search
    posts = Post.tagged_with(params[:tag])
    @meta, @posts = pagy(posts)

    render :'api/v1/posts/index', formats: :json
  end

  # Liked users
  # GET /api/v1/posts/:id/users
  def users
    users = User.post_voted(@post.id)
    @meta, @users = pagy(users)
  end

  # GET api/v1/posts/liked
  def liked
    @meta, @posts = pagy(Post.voted_by(current_user.id))
  end

  private

  def authorize_user
    authorize @post
  end

  def set_post
    @post = Post.find_by(id: params[:id])

    raise_if_blank(@post, 'Post')
  end

  def posts_params
    params.require(:post).permit(:content, :tag_list)
  end
end
