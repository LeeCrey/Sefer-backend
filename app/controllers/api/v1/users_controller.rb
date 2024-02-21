# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_user, except: %i[index blocked_users videos search]
  before_action :authorize_user, only: %i[show posts videos]

  # GET /api/v1/users
  # GET /api/v1/users.json
  def index
    users = User.neither_blocked_nor_followed_by(current_user.id)

    @meta, @users = pagy(users)
  end

  # GET /api/v1/users/:id
  # GET /api/v1/users/:id.json
  def show
    authorize @user

    @followers_count = @user.followers.count
    @followings_count = @user.following_users.count
    @posts_count = @user.posts.count
  end

  # POST /api/v1/users/:id/block
  # POST /api/v1/users/:id/block.json
  def block
    @block = Block.new(user_id: current_user.id, blocked_user_id: @user.id)

    if @block.save
      render_success(I18n.t('blocked', user: @user.full_name))
    else
      render_model_errors(@block)
    end
  end

  # DELETE /api/v1/users/:id/unblock
  # DELETE /api/v1/users/:id/unblock.json
  def unblock
    @blocked = current_user.unblock(@user)

    render_error(I18n.t('was_not_blocked')) and return if @blocked.blank?
  end

  # GET api/v1/users/blocked
  def blocked_users
    @meta, @users = pagy(current_user.blocked_users.order(id: :asc))

    render :index
  end

  # GET api/v1/users/videos
  def videos
    @meta, @videos = pagy(@user.short_videos.order(id: :desc))

    render :'api/v1/short_videos/index'
  end

  # GET api/v1/users/:id/posts
  def posts
    @meta, @posts = pagy(@user.posts_all(current_user.id).order(id: :desc))
  end

  # GET api/v1/users/search
  def search
    users = User.neither_blocked_nor_followed_by(current_user.id).where(search_condition)

    @meta, @users = pagy(users)

    render :'api/v1/users/index', format: :json
  end

  private

  def authorize_user
    authorize @user
  end

  def set_user
    @user = User.find_by(id: params[:id])

    raise_if_blank(@user, 'User')
  end

  def search_condition
    qry = params[:q]
    if qry.starts_with? '@'
      { username: qry.delete('@') }
    elsif qry.starts_with? '#'
      # hoby
    else
      { full_name: qry }
    end
  end
end
