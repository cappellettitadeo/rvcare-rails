# frozen_string_literal: true

module Users
  class UnlocksController < Devise::UnlocksController
    layout 'full_width', only: %i[new create]
    def create
      @email_empty = params[:user][:email].empty?
      super
    end
  end
end
