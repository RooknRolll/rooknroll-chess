require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#index action" do
    it "should successfully show the page" do
       player = create(:player)
       game = create(:game, black_player_id: nil)
       sign_in player
       get :index
       expect(response).to have_http_status(:success)
    end
  end
end
