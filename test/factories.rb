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
    user

    after(:create) { |model| refresh_index(model) }
  end

  factory :user do
    email { Faker::Internet.email }
    password { SecureRandom.alphanumeric }
  end

  factory :access_token do
    user
  end

  factory :visit, class: "Ahoy::Visit" do
    user
  end

  factory :event, class: "Ahoy::Event" do
    visit
    user { visit.user }
    time { Time.now }

    trait :view do
      transient do
        record { build(:songsheet) }
      end

      name { "view" }
      properties { {id: record.id, type: record.model_name.name} }
    end
  end

  factory :reference do
    record { build(:track) }

    trait :musixmatch do
      source { "musixmatch" }
      identifier { "mm-#{record.id}" }

      data do
        {
          "lyrics_copyright" => "© 2021 MusixMatch",
          "script_tracking_url" => "https://www.musixmatch.com/track/123",
          "pixel_tracking_url" => "https://www.musixmatch.com/track/123/pixel"
        }
      end
    end
  end
end
