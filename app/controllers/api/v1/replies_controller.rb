# frozen_string_literal: true

class Api::V1::RepliesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_comment, only: %i[create index]

  # POST /api/v1/comments/:comment_id/replies
  # POST /api/v1/comments/:comment_id/replies.json
  def index
    @meta, @repies = pagy(@comment.repies)
  end

  # POST /api/v1/comments/:comment_id/replies
  # POST /api/v1/comments/:comment_id/replies.json
  def create
    @reply = @comment.replies.new(reply_params)
    @reply.user_id = current_user.id
    @reply.post = @comment.post

    render_model_errors(@reply) unless @reply.save
  end

  private

  def set_comment
    @comment = Comment.find_by(id: params[:comment_id])

    raise_if_blank(@comment, 'Comment')
  end

  def reply_params
    params.require(:comment).permit(:content)
  end
end
