# frozen_string_literal: true

module RegistrationsConcern
  private

  def respond_with(resource, _opts = {})
    if resource.errors.empty? && resource.persisted?
      msg = I18n.t('devise.registrations.signed_up_but_unconfirmed')

      render json: { okay: true, _message: msg }, status: :created
    else
      render_model_errors(resource)
    end
  end

  def sign_up_params
    params.require(:user).permit(:full_name, :email, :password, :biography,
                                 :password_confirmation, :country, :gender)
  end

  def account_update_params
    params.require(:user).permit(:full_name, :country, :gender, :biography,
                                 :password, :current_password, :password_confirmation)
  end
end
