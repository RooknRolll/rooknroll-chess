class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :set_game, only: [:show, :update]

  def index
    @games = Game.all
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
    @game.update(black_player: current_player)
    redirect_to game_path(set_game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
