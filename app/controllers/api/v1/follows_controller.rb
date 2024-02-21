# frozen_string_literal: true

class Api::V1::FollowsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_user
  before_action :authorize_user, except: %i[unfollow]

  # POST /api/v1/users/:id/follow
  # POST /api/v1/users/:id/follow.json
  def follow
    @follow = Follow.new(follower_id: current_user.id, followed_id: @user.id)
    @follow.approved = @user.Public?
    if @follow.save
      render_success(I18n.t('follow', user: @user.full_name))
    else
      render_model_errors(@follow)
    end
  end

  # DELETE /api/v1/users/:id/unfollow
  # DELETE /api/v1/users/:id/unfollow.json
  def unfollow
    @follow = current_user.unfollow(@user)

    if @follow.present?
      render_success(I18n.t('unfollow', user: @user.full_name))
    else
      render_error(I18n.t('not_following'))
    end
  end

  # GET /api/v1/users/:id/followers
  # GET /api/v1/users/:id/followers.json
  def followers
    @meta, @users = pagy(@user.followers_with_status(current_user.id))
  end

  # GET /api/v1/users/:id/followings
  # GET /api/v1/users/:id/followings.json
  def followings
    users = if current_user.id == @user.id
              @user.following_users.with_attached_profile
            else
              @user.following_users_with_status(current_user.id).with_attached_profile
            end
    @meta, @users = pagy(users)
    @is_current_user = current_user.id == @user.id
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def authorize_user
    authorize @user
  end
end
