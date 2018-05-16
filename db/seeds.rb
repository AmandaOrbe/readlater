# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "open-uri"
require "yaml"

file = "db/seed_file.yml"
sample = YAML.load(open(file).read)

puts 'Creating users...'
users = {}  # slug => Director
sample["users"].each do |user|
  users[user["slug"]] = User.create! user.slice("email", "encrypted_password:")
end

puts 'Creating categories...'
sample["categories"].each do |category|
  user = users[category["user_slug"]]
  Category.create! category.slice("name", "color").merge(user: user)
end

puts 'Creating series...'
sample["articles"].each do |article|
  user = users[article["user_slug"]]
  category = categories[article["category_slug"]]
  Article.create! article.slice("url", "title", "image", "description").merge(user: user, category: category)
end
puts 'Finished!'

