class Player < ActiveRecord::Base
  has_many :pieces
  has_many :games

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |player|
    player.email = auth.info.email
    player.password = Devise.friendly_token[0,20]
  end
end

  validates :username, presence: true, length: {maximum: 255}, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]*\z/, message: "may only contain letters and numbers." }

  def games
    Game.where('black_player_id = :id OR white_player_id = :id', id: id)
        .where(game_over: false)
  end

  def other_player(game)
    game.other_player(self)
  end
end
