# frozen_string_literal: true

class Api::V1::ChatsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_chat, only: %i[show update destroy]

  # GET /api/v1/chats
  # GET /api/v1/chats.json
  def index
    @chats = Chat.user_chats(current_user.id)
  end

  # GET /api/v1/chats/1
  # GET /api/v1/chats/1.json
  def show
  end

  # POST /api/v1/chats
  # POST /api/v1/chats.json
  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      render :show, status: :created
    else
      render_model_errors(@chat)
    end
  end

  # PATCH/PUT /api/v1/chats/1
  # PATCH/PUT /api/v1/chats/1.json
  def update
    authorize @chat

    render_model_errors(@chat) unless @chat.update(chat_params)
  end

  # DELETE /api/v1/chats/1
  # DELETE /api/v1/chats/1.json
  def destroy
    authorize @chat

    @chat.destroy!
  end

  private

  def set_chat
    @chat = Chat.find_by(id: params[:id])

    raise_if_blank(@chat, 'Chat')
  end

  def chat_params
    params.require(:chat).permit(:name, :description, :chat_type, :cover)
  end
end
