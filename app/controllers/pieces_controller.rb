class PiecesController < ApplicationController
  before_action :authenticate_player!

  def show
    @chosen_piece = Piece.find(params[:id])
    @game = @chosen_piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    x_move = params[:x_coordinate].to_i
    y_move = params[:y_coordinate].to_i
    @piece.move(x_move, y_move)
    respond_to do |format|
      format.html {redirect_to game_path(@piece.game)}
      format.json { render json: @piece }
    end
  end

  private

  def piece_params
    params.permit(:x_coordinate, :y_coordinate)
  end

  helper_method :chosen

  def chosen
    [@chosen_piece.y_coordinate, @chosen_piece.x_coordinate]
  end
end
