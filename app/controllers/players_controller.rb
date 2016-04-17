class PlayersController < ApplicationController
  before_action :authenticate_player!, :player_is_current_player

  def show
    @player = player
  end

  private

  def player
    @player ||= Player.find(params[:id])
  end

  def player_is_current_player
    player == current_player
  end
end
