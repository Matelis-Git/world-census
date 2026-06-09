class User < ApplicationRecord
  has_many :user_countries, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :polls, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :conversations, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only letters, numbers and underscores" }, length: { minimum: 3, maximum: 20 }
  # Génère un avatar Gravatar à partir de l'email
  # MD5 est un algorithme de hachage — il transforme l'email en une suite de caractères unique
  def avatar_url(size = 40)
    hash = Digest::MD5.hexdigest(email.downcase.strip)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
  end
end
