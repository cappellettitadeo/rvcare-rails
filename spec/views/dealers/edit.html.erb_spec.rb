# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'dealers/edit', type: :view do
  before do
    @dealer = assign(:dealer, Dealer.create!)
  end

  it 'renders the edit dealer form' do
    render

    assert_select 'form[action=?][method=?]', dealer_path(@dealer), 'post' do
    end
  end
end
