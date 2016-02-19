class PiecesController < ApplicationController
  before_action :authenticate_player!

  def show
    @chosen_piece = Piece.find(params[:id])
    @game = @chosen_piece.game
  end

  private

  helper_method :chosen

  def chosen
    [@chosen_piece.y_coordinate, @chosen_piece.x_coordinate]
  end
end
