FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }

    trait :best_picture do
      name { 'Best Picture' }
    end

    trait :best_director do
      name { 'Best Director' }
    end

    trait :best_actor do
      name { 'Best Actor' }
    end

    trait :best_actress do
      name { 'Best Actress' }
    end

    trait :with_nominations do
      transient do
        nominations_count { 5 }
        nomination_year { 2025 }
      end
      after(:create) do |category, evaluator|
        oscar_year = OscarYear.find_or_create_by(id: evaluator.nomination_year) { |y| y.ceremony_on = Date.new(evaluator.nomination_year, 3, 2) }
        create_list(:nomination, evaluator.nominations_count,
                    category: category,
                    oscar_year_id: oscar_year.id)
      end
    end
  end
end
