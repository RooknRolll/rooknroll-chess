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
  end
end
