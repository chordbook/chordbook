def refresh_index(model)
  model.class.search_index.refresh if Searchkick.callbacks?
end

FactoryBot.define do
  factory :artist do
    name { Faker::Music.band }

    after(:create) { |model| refresh_index(model) }
  end

  factory :album do
    title { Faker::Music.album }
    artist

    after(:create) { |model| refresh_index(model) }
  end

  factory :track do
    title { Faker::Name.name }
    album
    artist { album.artist }

    after(:create) { |model| refresh_index(model) }
  end

  factory :songsheet do
    title { Faker::Name.name }

    trait :with_track do
      track
    end

    artists { [track&.artist].compact }

    after(:create) { |model| refresh_index(model) }
  end

  factory :genre do
    name { Faker::Music.genre }
  end

  factory :setlist do
    title { Faker::Music.genre }
  end

  factory :medium do
    uri { " https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
  end
end
