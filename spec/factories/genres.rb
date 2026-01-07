FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "Genre #{n}" }

    trait :drama do
      name { 'Drama' }
    end

    trait :comedy do
      name { 'Comedy' }
    end

    trait :action do
      name { 'Action' }
    end

    trait :thriller do
      name { 'Thriller' }
    end

    trait :documentary do
      name { 'Documentary' }
    end
  end
end
