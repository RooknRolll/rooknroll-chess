class PiecesController < ApplicationController
  before_action :authenticate_player!

  def show
    @chosen_piece = Piece.find(params[:id])
    @game = @chosen_piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    # This unless statement will keep you from making invalid moves. I think
    # this may break once we revove the interstitial from the movement action.
    # Also, since only the Bishop and King currently have the valid_move? method
    # defined movement won't be possible until the method is made for the other
    # pieces.  Remove this comment when you the other pieces are finished.
    x_move = params[:x_coordinate].to_i
    y_move = params[:y_coordinate].to_i
    return redirect_to :back unless @piece.valid_move?(x_move, y_move)
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
