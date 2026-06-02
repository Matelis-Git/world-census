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
Poll.destroy_all
User.destroy_all

usertest = User.create!(
  email: "test@test.com",
  password: "123456",
))

Poll.create!([
  {
    title_question: "Should France raise the minimum wage?",
    category: "economy",
    country: "france",
    user: usertest
  },
  {
    title_question: "Is nuclear energy the future of global power?",
    category: "politics",
    country: "global",
    user: usertest
  },
  {
    title_question: "Will PSG win the Champions this year?",
    category: "social",
    country: "global",
    user: usertest
  },
  {
    title_question: "Should week-ends be 4 days long?",
    category: "social",
    country: "france",
    user: usertest
  },
])

p "Seeded #{Poll.count} polls and #{User.count} users"
