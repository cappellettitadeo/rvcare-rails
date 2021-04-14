# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit

  before_action :authenticate_user!

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end
end
