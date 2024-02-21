# frozen_string_literal: true

class Api::V1::CommunityMembersController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_community, only: %i[join index]

  # GET /api/v1/communities/:id/members
  def index
    # non blocked, add status of following or not
    users = @community.members_with_status(current_user.id)
    @pagy, @users = pagy(users)

    render :'api/v1/users/index'
  end

  # POST /api/v1/communities/:id/join
  def join
    @member = @community.members.new(user_id: current_user.id)
    if @member.save
      render_success(I18n.t('joined', community: @community.name))
    else
      render_model_errors(@member)
    end
  end

  # DELETE /api/v1/communities/:id/leave
  def leave
    # if owner?
    CommunityMember.destroy_by(user_id: current_user.id, community_id: params[:id])
  end

  # POST /api/v1/community_members/:id/approve
  def approve
    # authorize
    @member = CommunityMember.find_by(id: params[:id])

    raise_if_blank(@member, 'Member')
  end

  private

  def set_community
    @community = Community.find_by(id: params[:id])

    raise_if_blank(@community, 'Community')
  end
end
