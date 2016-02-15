FactoryGirl.define do

  factory :user, aliases: [:player] do
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
    color 'white'
    x_coordinate 2
    y_coordinate 2
    factory :queen do
      type 'queen'
    end
    factory :bishop do
      type 'bishop'
    end
    factory :knight do
      type 'knight'
    end
    factory :rook do
      type 'rook'
    end
    factory :pawn do
      type 'pawn'
    end
    factory :king do
      type 'king'
    end
  end
end
