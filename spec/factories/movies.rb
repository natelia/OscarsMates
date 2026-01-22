FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "Movie #{n}" }
    sequence(:english_title) { |n| "English Title #{n}" }
    where_to_watch { 'Cinema' }
    rating { 7.5 }
    runtime { 120 }
    url { 'https://example.com/movie' }
    picture_url { 'https://example.com/picture.jpg' }

    trait :with_reviews do
      transient do
        reviews_count { 3 }
        review_year { 2025 }
      end
      after(:create) do |movie, evaluator|
        create(:nomination, movie: movie, year: evaluator.review_year)
        create_list(:review, evaluator.reviews_count, movie: movie, year: evaluator.review_year)
      end
    end

    trait :with_nomination do
      transient do
        nomination_year { 2025 }
        nomination_category { nil }
      end
      after(:create) do |movie, evaluator|
        category = evaluator.nomination_category || create(:category)
        create(:nomination, movie: movie, category: category, year: evaluator.nomination_year)
      end
    end

    trait :with_genres do
      transient do
        genres_count { 2 }
      end
      after(:create) do |movie, evaluator|
        genres = create_list(:genre, evaluator.genres_count)
        genres.each do |genre|
          create(:characterization, movie: movie, genre: genre)
        end
      end
    end

    trait :highly_rated do
      rating { 9.0 }
    end

    trait :low_rated do
      rating { 4.0 }
    end

    trait :short do
      runtime { 90 }
    end

    trait :long do
      runtime { 180 }
    end
  end
end
