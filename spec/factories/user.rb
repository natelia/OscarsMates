FactoryBot.define do
  factory :user do
    name { 'User' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
