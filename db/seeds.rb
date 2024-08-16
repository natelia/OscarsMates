# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Movie.destroy_all

movies = [
  {
    title: "Oppenheimer",
    english_title: "Oppenheimer",
    where_to_watch: "Amazon Prime Video, Apple Tv",
    runtime: 180,
    rating: 8.3,
    url: "https://www.imdb.com/title/tt15398776/",
    picture_url: "https://fwcdn.pl/fpo/28/17/10002817/8072064_2.3.jpg"
  },
  {
    title: "Przesilenie Zimowe",
    english_title: "The Holdovers",
    where_to_watch: "Amazon Prime Video",
    runtime: 133,
    rating: 7.9,
    url: "https://www.imdb.com/title/tt14849194/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BNDc2MzNkMjMtZDY5NC00NmQ0LWI1NjctZjRhNWIzZjc4MGRiXkEyXkFqcGdeQXVyMjkwOTAyMDU@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Amerykańska Fikcja",
    english_title: "American Fiction",
    where_to_watch: "Amazon Prime Video",
    runtime: 117,
    rating: 7.5,
    url: "https://www.imdb.com/title/tt23561236/",
    picture_url: "https://pomfort.com/news/wp-content/uploads/2024/02/American-Fiction-Movie-Poster.jpg"
  },
  {
    title: "Strefa Interesów",
    english_title: "The Zone of Interest",
    where_to_watch: "Amazon Prime Video",
    runtime: 105,
    rating: 7.4,
    url: "https://www.imdb.com/title/tt7160372/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BYzRmOGQwZjktYjM2Ni00M2NmLWFlZDYtZGFhM2RkM2VhZDI1XkEyXkFqcGdeQXVyMTM1NjM2ODg1._V1_.jpg"
  },
  {
    title: "Barbie",
    english_title: "Barbie",
    where_to_watch: "Amazon Prime Video, Max",
    runtime: 114,
    rating: 6.8,
    url: "https://www.imdb.com/title/tt1517268/?ref_=fn_al_tt_1",
    picture_url: "https://fwcdn.pl/fpo/48/00/754800/8077768_1.3.jpg"
  },
  {
    title: "Biedne Istoty",
    english_title: "Poor Things",
    where_to_watch: "Amazon Prime Video",
    runtime: 141,
    rating: 7.8,
    url: "https://www.imdb.com/title/tt14230458/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BNGIyYWMzNjktNDE3MC00YWQyLWEyMmEtN2ZmNzZhZDk3NGJlXkEyXkFqcGdeQXVyMTUzMTg2ODkz._V1_.jpg"
  },
  {
    title: "Poprzednie Życie",
    english_title: "Past Lives",
    where_to_watch: "Amazon Prime Video",
    runtime: 105,
    rating: 7.8,
    url: "https://www.imdb.com/title/tt13238346/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BOTkzYmMxNTItZDAxNC00NGM0LWIyODMtMWYzMzRkMjIyMTE1XkEyXkFqcGdeQXVyMTAyMjQ3NzQ1._V1_.jpg"
  },
  {
    title: "Amnatomia Upadku",
    english_title: "Amatomy of a Fall",
    where_to_watch: "Max",
    runtime: 143,
    rating: 7.7,
    url: "https://www.imdb.com/title/tt17009710/",
    picture_url: "https://m.media-amazon.com/images/S/pv-target-images/daef38beeba0260d9d2ec63127b1083088b438c45aac9d9ac2af09b5c55ff3bd.jpg"
  },
  {
    title: "Maestro",
    english_title: "Maestro",
    where_to_watch: "Netflix",
    runtime: 129,
    rating: 6.5,
    url: "https://www.imdb.com/title/tt5535276/",
    picture_url: "https://fwcdn.pl/fpo/39/56/843956/8100960_1.3.jpg"
  },
  {
    title: "Czas Krwawego Księzyca",
    english_title: "Killers of the Flower Moon",
    where_to_watch: "Amazon Prime Video",
    runtime: 216,
    rating: 7.6,
    url: "https://www.imdb.com/title/tt5537002/",
    picture_url: "https://fwcdn.pl/fpo/52/04/805204/8092241_2.3.jpg"
  },
  {
    title: "Rustin",
    english_title: "Rustin",
    where_to_watch: "Amazon Prime Video",
    runtime: 106,
    rating: 6.5,
    url: "https://www.imdb.com/title/tt14160834/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZDc2MDIzYzAtOWUzZS00ZjJmLWE4ZGMtMWZlNDc2OTQ5NzFjXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_.jpg"
  },
  {
    title: "Nyad",
    english_title: "Nyad",
    where_to_watch: "Netflix",
    runtime: 121,
    rating: 7.1,
    url: "https://www.imdb.com/title/tt5302918/",
    picture_url: "https://fwcdn.pl/fpo/03/34/870334/8094341_1.3.jpg"
  },
  {
    title: "Ja, Kapitan",
    english_title: "Io Capitano",
    where_to_watch: "Apple Tv",
    runtime: 121,
    rating: 7.6,
    url: "https://www.imdb.com/title/tt14225838/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BM2IxNjg4MmQtNmJmMi00MjNlLWFlMjAtMzI4M2FkNTFjMTU1XkEyXkFqcGdeQXVyMjUzMTYzMDI@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Śnieżne Braterstwo",
    english_title: "Society of the Snow",
    where_to_watch: "Netflix",
    runtime: 144,
    rating: 7.8,
    url: "https://www.imdb.com/title/tt16277242/",
    picture_url: "https://resizing.flixster.com/Fu6AXk1vSqv9NdFS5ovTXuvI8F0=/ems.cHJkLWVtcy1hc3NldHMvbW92aWVzLzBiOGRjNjE2LTdjOWUtNDRiNC04OWMyLTNkNDVjMDJiODVjZS5qcGc="
  },
  {
    title: "Perfect Days",
    english_title: "Perfect Days",
    where_to_watch: "Amazona Prime Video",
    runtime: 124,
    rating: 7.9,
    url: "https://www.imdb.com/title/tt27503384/",
    picture_url: "https://m.media-amazon.com/images/S/pv-target-images/20d3a8cb35d5e335ff273359d96f7b2cb9155df147810078930f58937d9249b4.jpg"
  },
  {
    title: "Pokój Nauczycielski",
    english_title: "The Teachers' Lounge",
    where_to_watch: "Netflix",
    runtime: 98,
    rating: 7.5,
    url: "https://www.imdb.com/title/tt26612950/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BYjc3MTM5MzktNTUwYi00ODRjLTliOTMtYWJiZTQ2NzhlZjJlXkEyXkFqcGdeQXVyMTQyODg5MjQw._V1_.jpg"
  },
  {
    title: "Chłopiec i Czapla",
    english_title: "The Boy and the Heron",
    where_to_watch: "Apple Tv, Amazon Prime Video",
    runtime: 124,
    rating: 7.5,
    url: "https://www.imdb.com/title/tt6587046/",
    picture_url: "https://kulturaliberalna.pl/wp-content/uploads/2024/01/Chlopiec-i-czapla-PLAKAT-alternatywny-online.jpg"
  },
  {
    title: "Nimona",
    english_title: "Nimona",
    where_to_watch: "Netflix",
    runtime: 101,
    rating: 7.5,
    url: "https://www.imdb.com/title/tt19500164/",
    picture_url: "https://wydajenamsie.pl/wp-content/uploads/2022/12/nimona_300dpi.jpg"
  },
  {
    title: "Pies i Robot",
    english_title: "Robot Dreams",
    where_to_watch: "Netflix",
    runtime: 103,
    rating: 7.6,
    url: "https://www.imdb.com/title/tt13429870/",
    picture_url: "https://fwcdn.pl/fpo/61/02/10036102/8102047_2.3.jpg"
  },
  {
    title: "Między Nami Żywiołami",
    english_title: "Elemental",
    where_to_watch: "Disney+",
    runtime: 103,
    rating: 7.6,
    url: "https://www.imdb.com/title/tt15789038/",
    picture_url: "https://lumiere-a.akamaihd.net/v1/images/p_disneyplusoriginals_elemental_poster_rebrand_a0788af2.jpeg"
  },
  {
    title: "Między Nami Żywiołami",
    english_title: "Elemental",
    where_to_watch: "Disney+",
    runtime: 103,
    rating: 7.6,
    url: "https://www.imdb.com/title/tt15789038/",
    picture_url: "https://lumiere-a.akamaihd.net/v1/images/p_disneyplusoriginals_elemental_poster_rebrand_a0788af2.jpeg"
  },
]

movies.each do |movie|
  Movie.create!(movie)
end
