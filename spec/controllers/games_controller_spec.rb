require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  before do
    player = create(:player)
    sign_in player
  end

  describe "games#index action" do
    it "should successfully show the page" do
       game = create(:game, black_player_id: nil)
       get :index
       expect(response).to have_http_status(:success)
    end

    it "should show all open games on page" do
       # @opengames should not be causing errors
       opengames = create(:game, black_player_id: nil)
       if opengames.present?
        get :index
       end
       expect(response). to have_http_status(:success)
    end
  end

  describe 'games#create action' do
    it "should set the game's white_player_id to the current_player's id" do
      white_player = create(:white_player)
      sign_in white_player
      post :create, game: { name: 'Lol' }

      expect(Game.first.white_player_id).to eq(white_player.id)
    end

    it "should redirect to the game show page" do
      white_player = create(:white_player)
      sign_in white_player
      post :create, game: { name: 'Lol' }
      game_id = Game.first.id

      expect(response).to redirect_to(game_path(game_id))
    end
  end
end
