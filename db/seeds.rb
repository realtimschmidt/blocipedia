require 'random_data'

# Create Users
5.times do
  User.create!(
  email:    Faker::Internet.email,
  password: RandomData.random_sentence
  )
end

# Create admin user
admin = User.create!(
  email:    'admin@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role:     'admin'
)

# Create premium user
premium = User.create!(
  email:    'member@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role:     'premium'
)

# Create standard user
standard = User.create!(
  email:    'user@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  role:     'standard'
)
users = User.all

# Create Wikis
50.times do
  Wiki.create!(
    user:   users.sample,
    title:  Faker::Name.title,
    body:   RandomData.random_paragraph
  )
end

5.times do
  Wiki.create!(
    user:     users.sample,
    title:    'Private - ' + Faker::Lorem.sentence,
    body:     Faker::Lorem.paragraph,
    private:  true
  )
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
