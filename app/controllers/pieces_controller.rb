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
    move_data = @piece.move(x_move, y_move)
    respond_to do |format|
      format.html { redirect_to game_path(@piece.game) }
      format.json { render json: move_data }
    end
  end

  def promote
    @piece = Piece.find(params[:id])
    puts params
    promotion_results = @piece.promote(type_from_params)
    respond_to do |format|
      format.html
      format.json { render json: promotion_results }
    end
  end

  private

  def piece_params
    params.permit(:x_coordinate, :y_coordinate)
  end

  def type_from_params
    # To prevent bad data from being placed in the database by people using the
    # console, require the given type to be in set boundaries. Otherwise, just
    # assume they want a queen.
    piece_types = %w(Queen Rook Knight Bishop)
    piece_types.include?(params[:type]) ? params[:type] : 'Queen'
  end

  helper_method :chosen

  def chosen
    [@chosen_piece.y_coordinate, @chosen_piece.x_coordinate]
  end
end
