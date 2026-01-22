FactoryBot.define do
  factory :review do
    association :movie
    association :user
    watched_on { Time.zone.today }
    stars { 7 }

    trait :with_comment do
      comment { 'Great movie! Highly recommend.' }
    end

    trait :excellent do
      stars { 10 }
      comment { 'Absolutely amazing!' }
    end

    trait :good do
      stars { 8 }
    end

    trait :average do
      stars { 5 }
    end

    trait :poor do
      stars { 2 }
    end

    trait :watched_recently do
      watched_on { 1.day.ago }
    end

    trait :watched_long_ago do
      watched_on { 1.year.ago }
    end
  end
end
