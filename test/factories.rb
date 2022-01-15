FactoryBot.define do
  factory :artist do
    name { Faker::Music.band }
  end

  factory :album do
    title { Faker::Music.album }
    artist
  end

  factory :track do
    title { Faker::Name.name }
    album
    artist { album.artist }
  end

  factory :songsheet do
    trait :with_track do
      track
    end

    artists { [track&.artist].compact }
  end

  factory :genre do
    name { Faker::Music.genre }
  end
end
