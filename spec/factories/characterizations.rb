FactoryBot.define do
  factory :characterization do
    association :movie
    association :genre
  end
end
