FactoryBot.define do
  factory :nomination do
    association :movie
    association :category
    name { 'Best Performance' }
    year { 2025 }

    trait :year_2024 do
      year { 2024 }
    end

    trait :year_2025 do
      year { 2025 }
    end
  end
end
