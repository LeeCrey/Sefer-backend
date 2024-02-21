# frozen_string_literal: true

class HelpersController < ApplicationController
  before_action :authenticate_user!, except: %i[asset_links]

  def fcm_update
    token = params[:notification]

    render_json_error({ error: 'Token is missing' }, :unprocessable_entity) and return if token.blank?

    current_student.update(notification_token: token)

    render_created({ _message: I18n.t('added', resource: 'Token') })
  end

  def asset_links
    render file: Rails.public_path.join('assetlinks.json'),
           content_type: 'application/json', layout: false
  end
end
