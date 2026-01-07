FactoryBot.define do
  factory :user do
    name { 'User' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
  end
end
