FactoryBot.define do
  factory :movie do
    title { "Movie" }
    english_title { 'English Title' }
    where_to_watch { 'Cinema' }
    rating { 5 }
    runtime { 100 }
    url { 'example.com' }
    picture_url { 'picture-example.com' }
  end
end