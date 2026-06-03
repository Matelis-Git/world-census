# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Vote.destroy_all
PollOption.destroy_all
Poll.destroy_all
User.destroy_all

usertest = User.create!(
  email: "test@test.com",
  password: "123456",
)

usertest2 = User.create!(
  email: "user@test.com",
  password: "123456",
)

polls_with_options = [
  {
    poll: { title_question: "Should France raise the minimum wage?", category: "economy", country: "france", user: usertest },
    options: ["Yes, significantly", "Yes, but gradually", "No, keep it as is", "No, it should be lowered"]
  },
  {
    poll: { title_question: "Is nuclear energy the future of global power?", category: "politics", country: "global", user: usertest },
    options: ["Yes, it's our best option", "Only as a transition energy", "No, renewables are enough"]
  },
  {
    poll: { title_question: "Will PSG win the Champions League this year?", category: "social", country: "global", user: usertest },
    options: ["Definitely yes", "Maybe, it's possible", "Unlikely", "No chance"]
  },
  {
    poll: { title_question: "Should weekends be 4 days long?", category: "social", country: "france", user: usertest },
    options: ["Yes, absolutely", "Yes, but only some workers", "No, 2 days is fine"]
  },
  {
    poll: { title_question: "Should you leave the lights on in the dark?", category: "social", country: "global", user: usertest2 },
    options: ["Yes, always", "Only in certain rooms", "No, save electricity"]
  },
]

polls_with_options.each do |entry|
  poll = Poll.create!(entry[:poll])
  entry[:options].each { |text| poll.poll_options.create!(text: text) }
end

p "Seeded #{Poll.count} polls, #{PollOption.count} options, and #{User.count} users"
