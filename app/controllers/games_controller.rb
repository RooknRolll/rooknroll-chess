class GamesController < ApplicationController
  def index
    @game = Game.new
  end

  def new
  end

  def create
  end

  def show
    @game = Game.find(params[:id])
    @pieces = @game.pieces.order(:y_coordinate, :x_coordinate)
  end
end
