class PiecesController < ApplicationController
  before_action :authenticate_player!

  def show
    @chosen_piece = Piece.find(params[:id])
    @game = @chosen_piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    # We still need to validate the move. Right now you can do pretty much
    # anything. The validation methods should be written in the model, and
    # called here.
    @piece.update(piece_params)
    redirect_to game_path(@piece.game)
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
