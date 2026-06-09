class User < ApplicationRecord
  has_many :user_countries, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :polls, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :conversations, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only letters, numbers and underscores" }, length: { minimum: 3, maximum: 20 }
end
