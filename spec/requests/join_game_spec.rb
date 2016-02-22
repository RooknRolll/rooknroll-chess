require 'rails_helper'

RSpec.describe "Join a Game", type: :request do
  it "works! (now write some real specs)" do
    player = create(:player)
    game = create(:game, black_player_id: nil)
    
    # login player
    post player_session_path, player: { login: player.username, password: "secretPassword" }
    
    # visit games index page
    get games_path
    assert_select 'a', {text: 'Join Game', count: 1}
    
    # join a game
    put game_path(game)
    get game_path(game)
    assert_select 'table'
  end
end
