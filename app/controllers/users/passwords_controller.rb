# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # POST /users/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    render_success(I18n.t('devise.passwords.send_paranoid_instructions'))
  end

  private

  def respond_with(resource, _opts = {})
    if resource.errors.any?
      render_model_errors(resource)
    else
      render_success(I18n.t('devise.passwords.updated_not_active'))
    end
  end
end
