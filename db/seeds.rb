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
    title: "Anatomia Upadku",
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
    title: "Spider-Man: Poprzez multiwersum",
    english_title: "Spider-man: across the spider-verse",
    where_to_watch: "Max, Amazon Prime Video",
    runtime: 140,
    rating: 8.6,
    url: "https://www.imdb.com/title/tt9362722/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BMzI0NmVkMjEtYmY4MS00ZDMxLTlkZmEtMzU4MDQxYTMzMjU2XkEyXkFqcGdeQXVyMzQ0MzA0NTM@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Kolor Purpury",
    english_title: "The Color Purple",
    where_to_watch: "Max, Amazon Prime Video",
    runtime: 141,
    rating: 6.8,
    url: "https://www.imdb.com/title/tt1200263/",
    picture_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-5A_7TjkVR7nPTNexK9GrGTfBjvBixLpndw&s"
  },
  {
    title: "Obsesja",
    english_title: "May December",
    where_to_watch: "Max",
    runtime: 117,
    rating: 6.8,
    url: "https://www.imdb.com/title/tt13651794/",
    picture_url: "https://assets.upflix.pl/media/plakat/2023/may-december_5__300_427.jpg"
  },
  {
    title: "Indiana Jones i Artefakt Przeznaczenia",
    english_title: "Indiana Jones and the Dial of Destiny",
    where_to_watch: "Amazon Prime Video",
    runtime: 154,
    rating: 6.5,
    url: "https://www.imdb.com/title/tt1462764/",
    picture_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSeK015GWARYYS3-H82hMfZRk_uuFKvZGVg&s"
  },
  {
    title: "Godzilla Minus One",
    english_title: "Godzilla Minus One",
    where_to_watch: "Netflix",
    runtime: 124,
    rating: 7.7,
    url: "https://www.imdb.com/title/tt23289160/",
    picture_url: "https://i.ebayimg.com/images/g/SZEAAOSwayRlmLZ5/s-l1200.webp"
  },
  {
    title: "Strażnicy Galaktyki: Volume 3",
    english_title: "Guardians of the Galaxy Vol. 3",
    where_to_watch: "Disney+",
    runtime: 124,
    rating: 7.7,
    url: "https://www.imdb.com/title/tt23289160/",
    picture_url: "https://i.ebayimg.com/images/g/SZEAAOSwayRlmLZ5/s-l1200.webp"
  },
  {
    title: "Hrabia",
    english_title: "El Conde",
    where_to_watch: "Netflix",
    runtime: 110,
    rating: 6.5,
    url: "https://www.imdb.com/title/tt21113540/",
    picture_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTwOeO4ty0CFU6wCJTKieS8hrXiE5YMHrsuA&s"
  },
  {
    title: "Napoleon",
    english_title: "Napoleon",
    where_to_watch: "CinemaCity, Mulikino",
    runtime: 158,
    rating: 6.5,
    url: "https://www.imdb.com/title/tt13287846/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZWIzNDAxMTktMDMzZS00ZjJmLTlhNjYtOGUxYmZlYzVmOGE4XkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Mission: Impossible - Dead Reckoning Part One",
    english_title: "Mission: Impossible - Dead Reckoning Part One",
    where_to_watch: "VOD",
    runtime: 100,
    rating: 6.0,
    url: "https://www.imdb.com/title/tt9603212/",
    picture_url: "https://sck.stargard.pl/wp-content/uploads/2023/06/Mission-Impossible-Dead-Reckoning-Part-One-1.jpg"
  },
  {
    title: "Twórca",
    english_title: "The Creator",
    where_to_watch: "Disney+",
    runtime: 133,
    rating: 6.8,
    url: "https://www.imdb.com/title/tt11858890/",
    picture_url: "https://lumiere-a.akamaihd.net/v1/images/p_disney_thecreator_v1_2776_cc1a5f09.jpeg?region=0%2C0%2C540%2C810"
  },
  {
    title: "Golda",
    english_title: "Golda",
    where_to_watch: "VOD",
    runtime: 100,
    rating: 6.0,
    url: "https://www.imdb.com/title/tt14454876/",
    picture_url: "https://fwcdn.pl/fpo/25/74/872574/8095108_2.3.jpg"
  },
  {
    title: "Flamin' Hot: Smak Sukcesu",
    english_title: "Flamin' Hot",
    where_to_watch: "Disney+",
    runtime: 99,
    rating: 6.9,
    url: "https://www.imdb.com/title/tt8105234/",
    picture_url: "https://fwcdn.pl/fpo/01/97/10030197/8071071_1.3.jpg"
  },
  {
    title: "Jon Batiste: Amerykańska symfonia",
    english_title: "American Symphony",
    where_to_watch: "Netflix",
    runtime: 104,
    rating: 7.1,
    url: "https://www.imdb.com/title/tt28865980/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZmRiYjQ2MDItN2I5OC00Yjk1LTllYTEtMDZlZDAyZjgxZDVmXkEyXkFqcGdeQXVyMTAyMjQ3NzQ1._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "20 Dni w Mariupolu",
    english_title: "20 Days in Mariupol",
    where_to_watch: "Netflix",
    runtime: 95,
    rating: 8.6,
    url: "https://www.imdb.com/title/tt24082438/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZWRiNWRiZjAtYWFhMS00MWE5LTk0OTQtMzIxNzc0YmVmZGEwXkEyXkFqcGdeQXVyMzAyMzE2MzM@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Bobi Wine – Głos Sprzeciwu",
    english_title: "Bobi Wine: The People's President",
    where_to_watch: "Disney+",
    runtime: 113,
    rating: 7.4,
    url: "https://www.imdb.com/title/tt21376900/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BNWU3NTcyZGMtZjE4ZS00NGI2LWJkOTYtY2E1ZDA3YzQxNGFmXkEyXkFqcGdeQXVyMTY3ODkyNDkz._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "To Kill a Tiger",
    english_title: "Zabić tygrysa",
    where_to_watch: "Netflix",
    runtime: 125,
    rating: 7.9,
    url: "https://www.imdb.com/title/tt21688772/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BMWQ4NjMwYTUtNjE0OC00MTYyLWE4MGQtYTEzNjYwZTA3NDM4XkEyXkFqcGdeQXVyMzM2Mzc4NTU@._V1_.jpg"
  },
  {
    title: "Cztery Córki",
    english_title: "Four Daughters",
    where_to_watch: "Netflix",
    runtime: 107,
    rating: 7.4,
    url: "https://www.imdb.com/title/tt21688772/",
    picture_url: "https://fwcdn.pl/fpo/43/39/10034339/8112996_1.3.jpg"
  },
  {
    title: "Pamięć jest Wieczna",
    english_title: "The Eternal Memory",
    where_to_watch: "Netflix",
    runtime: 85,
    rating: 7.8,
    url: "https://www.imdb.com/title/tt21688772/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BOTFiMjFlZjEtMDM5Zi00MmIzLTliM2EtZTc3NjUzNzA3ZWI1XkEyXkFqcGdeQXVyMTYzMDUzNjEw._V1_.jpg"
  },
  {
    title: "List do Świni",
    english_title: "Letter to a Pig",
    where_to_watch: "Max",
    runtime: 17,
    rating: 7.0,
    url: "https://www.imdb.com/title/tt10346066/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BMzRhMjg0NDAtZjdkZC00YmE2LThjZWUtZDBmYjBhZmQ0NWFlXkEyXkFqcGdeQXVyODgxMDAxMjY@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Ninety-Five Senses",
    english_title: "Ninety-Five Senses",
    where_to_watch: "Max",
    runtime: 13,
    rating: 7.6,
    url: "https://www.imdb.com/title/tt11020596/",
    picture_url: "https://fwcdn.pl/fpo/68/74/10046874/8110617_2.3.jpg"
  },
  {
    title: "Pachydermia",
    english_title: "Pachyderme",
    where_to_watch: "Apple Tv",
    runtime: 11,
    rating: 7.2,
    url: "https://www.imdb.com/title/tt20862526/",
    picture_url: "https://images.justwatch.com/poster/311344738/s718/pachyderm.jpg"
  },
  {
    title: "WAR IS OVER! Inspired by the Music of John and Yoko",
    english_title: "WAR IS OVER! Inspired by the Music of John and Yoko",
    where_to_watch: "Amazon Prime Video",
    runtime: 11,
    rating: 6.9,
    url: "https://www.imdb.com/title/tt29795707/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZWMxNzhhZTItMzYzMC00NDIzLWJlMmItNTBmYTdlOTYxYWEyXkEyXkFqcGdeQXVyNTU4MTc2MjE@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Kawaler Fortuny",
    english_title: "Knight of Fortune",
    where_to_watch: "Amazon Prime Video",
    runtime: 25,
    rating: 7.1,
    url: "https://www.imdb.com/title/tt26600054/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BNTY4MjllYWYtMGVjMi00Y2EyLTk4NjYtOGI3YTU0OGUwODgxXkEyXkFqcGdeQXVyMTI2NzYyODM3._V1_.jpg"
  },
  {
    title: "Red, White and Blue",
    english_title: "Red, White and Blue",
    where_to_watch: "Amazon Prime Video",
    runtime: 23,
    rating: 7.1,
    url: "https://www.imdb.com/title/tt27759823/",
    picture_url: "https://m.media-amazon.com/images/I/81rgkm8ggSL._AC_UF1000,1000_QL80_.jpg"
  },
  {
    title: "The After",
    english_title: "The After",
    where_to_watch: "Netflix",
    runtime: 19,
    rating: 6.2,
    url: "https://www.imdb.com/title/tt28532006/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BMzhiZDRmOTktZjNmNy00ZDYyLTk2OGUtZGJmMmFlOWRjYzFhXkEyXkFqcGdeQXVyMTc0ODU3MjY@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Zdumiewająca historia Henry’ego Sugara",
    english_title: "The Wonderful Story of Henry Sugar",
    where_to_watch: "Netflix",
    runtime: 37,
    rating: 7.4,
    url: "https://www.imdb.com/title/tt16968450/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZjJjYzkyNWMtZTM2My00YWQ3LWJiODktMzc5YjhlNGY1Mjg5XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "Island in Between",
    english_title: "Island in Between",
    where_to_watch: "YouTube",
    runtime: 20,
    rating: 6.1,
    url: "https://www.imdb.com/title/tt30523942/",
    picture_url: "https://img.rgstatic.com/content/movie/4018fe8b-f921-4eb6-bf13-187956257df1/poster-500.jpg"
  },
  {
    title: "Nai Nai & Wài Pó",
    english_title: "Nai Nai & Wài Pó",
    where_to_watch: "Disney+",
    runtime: 17,
    rating: 7.8,
    url: "https://www.imdb.com/title/tt26218316/",
    picture_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuXoFtqV6tQ0qGS5zzPZB81b2PgHf3UO8APQ&s"
  },
  {
    title: "The Barber of Little Rock",
    english_title: "The Barber of Little Rock",
    where_to_watch: "Disney+",
    runtime: 35,
    rating: 6.5,
    url: "https://www.imdb.com/title/tt28627868/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BNmQ2ZjMyN2QtMzAzNC00NGYyLWJjYzAtYmUxZTY4YjI1NjEyXkEyXkFqcGdeQXVyMTIxMTcyMDI@._V1_FMjpg_UX1000_.jpg"
  },
  {
    title: "The ABCs of Book Banning",
    english_title: "The ABCs of Book Banning",
    where_to_watch: "YouTube",
    runtime: 27,
    rating: 6.3,
    url: "https://www.imdb.com/title/tt29361805/",
    picture_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOUxaXSroraO0atyMCbLzIW1Nds-SJuAWFLg&s"
  },
  {
    title: "Ostatni Warsztat",
    english_title: "The Last Repair Shop",
    where_to_watch: "YouTube",
    runtime: 39,
    rating: 7.4,
    url: "https://www.imdb.com/title/tt29118186/",
    picture_url: "https://m.media-amazon.com/images/M/MV5BZWNjZjFjMzEtMmRiYi00NjNiLWEyZDEtZDc0NDFlYTM3NTI4XkEyXkFqcGdeQXVyMTM1NjM2ODg1._V1_FMjpg_UX1000_.jpg"
  },
]

movies.each do |movie|
  Movie.create!(movie)
end

movies.each do |movie|
  unless Movie.exists?(title: movie[:title])
    Movie.create!(movie)
  end
end