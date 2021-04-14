# frozen_string_literal: true

class DealersController < ApplicationController
  before_action :set_dealer, only: %i[show edit update destroy]

  # GET /dealers/1/edit
  def edit; end

  # PATCH/PUT /dealers/1
  # PATCH/PUT /dealers/1.json
  def update
    respond_to do |format|
      if @dealer.update(dealer_params)
        format.html { redirect_to @dealer, notice: 'Dealer was successfully updated.' }
        format.json { render :show, status: :ok, location: @dealer }
      else
        format.html { render :edit }
        format.json { render json: @dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dealer
    @dealer = Dealer.first
  end

  # Only allow a list of trusted parameters through.
  def dealer_params
    params.fetch(:dealer, {})
  end
end
