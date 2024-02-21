# frozen_string_literal: true

class Api::V1::CommunitiesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_community, only: %i[show update destroy posts add_post]
  before_action :authorize_user, except: %i[index create discover]

  # GET /api/v1/communities
  # GET /api/v1/communities.json
  def index
    @meta, @communities = pagy(current_user.communities.order(members_count: :asc))
  end

  # GET /api/v1/communities/1
  # GET /api/v1/communities/1.json
  def show
  end

  # POST /api/v1/communities
  # POST /api/v1/communities.json
  def create
    @community = current_user.owned_communities.new(community_params)
    if @community.save
      add_current_user_to_members(@community)

      render_success(I18n.t('created', resource: 'Community'))
    else
      render_model_errors(@community)
    end
  end

  # PATCH/PUT /api/v1/communities/1
  # PATCH/PUT /api/v1/communities/1.json
  def update
    if @community.update(community_params)
      render_success(I18n.t('updated', resource: 'Community'))
    else
      render_model_errors(@community)
    end
  end

  # DELETE /api/v1/communities/1
  # DELETE /api/v1/communities/1.json
  def destroy
    @community.destroy!
  end

  # GET api/v1/communities/discover
  def discover
    ids = current_user.community_ids
    @meta, @communities = pagy(Community.where.not(id: ids))

    render :'api/v1/communities/index'
  end

  # GET api/v1/communities/:id/posts
  def posts
    @meta, @posts = pagy(@community.posts_with_status(current_user.id))

    render :'api/v1/posts/index'
  end

  # POST api/v1/communities/:id/posts
  def add_post
    @post = @community.posts.new(posts_params)
    @post.user_id = current_user.id

    if @post.save
      render_success(I18n.t('created', resource: 'Post'))
    else
      render_model_errors(@post)
    end
  end

  private

  def add_current_user_to_members(community)
    member = CommunityMember.new(user_id: current_user.id, community_id: community.id)
    member.approved = true
    member.save
  end

  def authorize_user
    authorize @community
  end

  def set_community
    @community = Community.find_by(id: params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :community_type, :description, :profile)
  end

  def posts_params
    params.require(:post).permit(:content, :tag_list)
  end
end
