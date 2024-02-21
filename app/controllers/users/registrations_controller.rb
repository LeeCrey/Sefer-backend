# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST /users
  # def create
  #   build_resource(sign_up_params)

  #   resource.save

  #   msg = I18n.t('devise.registrations.signed_up_but_unconfirmed')

  #   # I want user should check his/her mail rather than notifying the email is taken
  #   render json: { okay: true, message: msg }, status: :created
  # end

  def update
    if current_user.update_without_password(account_update_params)
      render_success(I18n.t('devise.registrations.updated'))
    else
      render_model_errors(current_user)
    end
  end

  include RegistrationsConcern
end
