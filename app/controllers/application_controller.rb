# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError,
              ActionController::ParameterMissing do |ex|
    render_bad_request(ex.message)
  end
  rescue_from ArgumentError do |ex|
    render_bad_request(ex.message)
  end
  rescue_from ActiveRecord::RecordNotFound do |ex|
    render json: { okay: false, reason: ex.message }, status: :not_found
  end
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Google::Auth::IDTokens::SignatureError, with: :google_auth_error
  rescue_from Google::Auth::IDTokens::ExpiredTokenError, with: :google_auth_error

  def page_not_found
    render json: { okay: false, reason: 'Page not found' }, status: :not_found
  end

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale]
  rescue I18n::InvalidLocale
    I18n.locale = :en # Fallback to the default "en" locale
  end

  include Pundit::Authorization

  def render_error(msg)
    render json: { okay: false, reason: msg }, status: :unprocessable_entity
  end

  def render_success(msg)
    render json: { okay: true, _message: msg }, status: :ok
  end

  def render_bad_request(msg)
    render json: { okay: false, reason: msg }, status: :bad_request
  end

  def raise_if_blank(resource, name)
    return if resource.present?

    raise ActiveRecord::RecordNotFound, I18n.t('not_found', resource: name)
  end

  def render_model_errors(model_instance)
    msg = model_instance.errors.full_messages.first

    render json: { okay: false, reason: msg }, status: :unprocessable_entity
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    msg = I18n.t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default

    unauthorized_response(msg)
  end

  def google_auth_error(exception)
    unauthorized_response(exception.message)
  end

  def unauthorized_response(msg)
    render json: { okay: false, reason: msg }, status: :unauthorized
  end
end
