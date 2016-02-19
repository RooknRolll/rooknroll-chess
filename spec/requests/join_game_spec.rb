require 'rails_helper'

RSpec.describe "Join a Game", type: :request do
  it "works! (now write some real specs)" do
    player = create(:player)
    game = create(:game, black_player_id: nil)
    post player_session_path, player: { login: player.username, password: "secretPassword" }
    # get join_games_path
    # expect(response).to have_http_status(200)
    # get game index
    put_via_redirect( game_path(game) )
  end
end
