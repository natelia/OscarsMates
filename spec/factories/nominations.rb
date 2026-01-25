FactoryBot.define do
  factory :nomination do
    association :movie
    association :category
    name { 'Best Performance' }

    transient do
      year { 2025 }
    end

    after(:build) do |nomination, evaluator|
      # Use oscar_year_id if explicitly set, otherwise use year transient
      year_to_use = nomination.oscar_year_id || evaluator.year
      next if year_to_use.nil?

      OscarYear.find_or_create_by(id: year_to_use) { |y| y.ceremony_on = Date.new(year_to_use, 3, 2) }
      nomination.oscar_year_id ||= year_to_use
    end

    trait :year_2024 do
      year { 2024 }
    end

    trait :year_2025 do
      year { 2025 }
    end
  end
end
