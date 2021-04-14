# frozen_string_literal: true

class UpdateSequences < ActiveRecord::Migration[6.1]
  def up
    execute('ALTER SEQUENCE dealers_id_seq RESTART WITH 1000')
    execute('ALTER SEQUENCE partners_id_seq RESTART WITH 1000')
  end
end
