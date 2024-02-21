# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  respond_to :json

  # POST /users/unlock
  def create
    self.resource = resource_class.send_unlock_instructions(resource_params)

    render_success(I18n.t('devise.unlocks.send_paranoid_instructions'))
  end

  # GET /users/unlock?unlock_token=abcdef
  def show
    self.resource = resource_class.unlock_access_by_token(params[:unlock_token])

    if resource.errors.empty?
      render_success(I18n.t('devise.unlocks.unlocked'))
    else
      render_model_errors(resource)
    end
  end
end
