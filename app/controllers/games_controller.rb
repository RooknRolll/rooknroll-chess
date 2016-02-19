class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :set_game, only: [:show, :update]

  def index
    
  end

  def new
    @game = Game.new
  end

  def create
  end

  def show
    @pieces = @game.pieces.order(:y_coordinate, :x_coordinate)
  end

  def update
    @game.black_player_id = current_player
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
