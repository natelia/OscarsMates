FactoryBot.define do
  factory :favorite do
    association :movie
    association :user
  end
end
