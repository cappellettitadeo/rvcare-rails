# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    layout 'full_width', only: %i[new create edit update]
  end
end
