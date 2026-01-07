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
        create_list(:nomination, evaluator.nominations_count,
                    category: category,
                    year: evaluator.nomination_year)
      end
    end
  end
end
