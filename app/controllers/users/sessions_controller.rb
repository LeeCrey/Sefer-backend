# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # POST /users/sign_in
  def create
    token = params[:Token]

    self.resource = if token.present?
                      sign_in_with_google(token)
                    else
                      warden.authenticate!(auth_options)
                    end

    sign_in(resource_name, resource)
  end

  include SessionsConcern
end
