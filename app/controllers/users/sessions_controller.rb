# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    layout 'full_width', only: [:new]
  end
end
