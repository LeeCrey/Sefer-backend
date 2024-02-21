# frozen_string_literal: true

module SessionsConcern
  private

  # LOGIN
  def respond_with(_resource, _opt = {})
    if user_signed_in?
      render :create, formats: :json
    else
      msg = I18n.t('devise.failure.invalid', authentication_keys: 'Email')

      unauthorized_response(msg)
    end
  end

  # LOGOUT
  def respond_to_on_destroy
    render_success(I18n.t('devise.sessions.already_signed_out'))
  end

  def sign_in_with_google(token)
    g_aud = ENV.fetch('GOOGLE_CLIENT_ID')
    payload = Google::Auth::IDTokens.verify_oidc(token, aud: g_aud)

    return null unless payload['aud'] == g_aud

    User.from_google_payload(payload)
  end
end
