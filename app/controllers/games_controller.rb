class GamesController < ApplicationController
  before_action :authenticate_player!
  before_action :set_game, only: [:show, :update]

  def index
    @opengames = Game.with_open_seats
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.white_player_id = current_player.id
    @game.save
    redirect_to game_path(@game)
  end

  def show
    @pieces = @game.pieces.order(:y_coordinate, :x_coordinate)
  end

  def update
    @game.update(black_player: current_player)
    redirect_to action: :show
  end

  def forfeit
    @forfeit = Game.delete 
  end

  helper_method :forfeit

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end
end
