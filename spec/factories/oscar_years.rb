FactoryBot.define do
  factory :oscar_year do
    id { 2025 }
    nominations_announced_on { Date.new(2025, 1, 23) }
    ceremony_on { Date.new(2025, 3, 2) }

    trait :year_2024 do
      id { 2024 }
      nominations_announced_on { Date.new(2024, 1, 23) }
      ceremony_on { Date.new(2024, 3, 10) }
    end

    trait :year_2025 do
      id { 2025 }
      nominations_announced_on { Date.new(2025, 1, 23) }
      ceremony_on { Date.new(2025, 3, 2) }
    end
  end
end
