module GamesHelper
  def square_order_by_color(game)
    game.white_player == current_player ? (0..7).to_a.reverse : (0..7).to_a
  end
end
