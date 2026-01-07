FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    admin { false }

    trait :admin do
      admin { true }
    end

    trait :with_reviews do
      transient do
        reviews_count { 3 }
      end
      after(:create) do |user, evaluator|
        create_list(:review, evaluator.reviews_count, user: user)
      end
    end

    trait :with_favorites do
      transient do
        favorites_count { 3 }
      end
      after(:create) do |user, evaluator|
        create_list(:favorite, evaluator.favorites_count, user: user)
      end
    end

    trait :with_followers do
      transient do
        followers_count { 3 }
      end
      after(:create) do |user, evaluator|
        create_list(:follow, evaluator.followers_count, followed: user)
      end
    end

    trait :with_following do
      transient do
        following_count { 3 }
      end
      after(:create) do |user, evaluator|
        create_list(:follow, evaluator.following_count, follower: user)
      end
    end
  end
end
