class Poll < ApplicationRecord
  has_many :conversations, dependent: :destroy
  belongs_to :user, optional: true
  has_many :votes, dependent: :destroy
  has_many :poll_options, dependent: :destroy
  accepts_nested_attributes_for :poll_options, reject_if: :all_blank
  validate :law_options_are_valid, if: -> { category == "law" }

  private

  def law_options_are_valid
    allowed = ["For", "Against", "Abstain"]
    return if poll_options.map(&:text) == allowed

    errors.add(:poll_options, "must be For, Against, Abstention for law category")
  end

  def to_globe_json
    { id: id, lat: lat, lon: lon, city: city, country: country,
      q: question, cat: category, votes: votes.count, isPoll: true }
  end
end
