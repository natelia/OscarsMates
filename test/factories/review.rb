FactoryBot.define do
  factory :review do
    association :movie
    association :user
    watched_on { Date.today }
    stars { 5 }
  end
end
