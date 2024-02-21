# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    render_success(I18n.t('devise.confirmations.send_paranoid_instructions'))
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      render_success(I18n.t('devise.confirmations.confirmed'))
    else
      render_model_errors(resource)
    end
  end
end
