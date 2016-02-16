FactoryGirl.define do
  factory :game do
    black_player
    white_player
  end

  factory :player, aliases: [:black_player, :white_player] do
    sequence :username do |n|
      "tets#{n}"
    end
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"

  end

  factory :piece do
    player
    game_id { FactoryGirl.create(:game).id }
    color 'white'
    x_coordinate 2
    y_coordinate 2
    factory :queen do
      type 'Queen'
    end
    factory :bishop do
      type 'Bishop'
    end
    factory :knight do
      type 'Knight'
    end
    factory :rook do
      type 'Rook'
    end
    factory :pawn do
      type 'Pawn'
    end
    factory :king do
      type 'King'
    end
  end
end
