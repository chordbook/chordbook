module ShortIdentifier
  extend ActiveSupport::Concern

  PREFIXES = {
    "x" => "AccessToken",
    "r" => "Album",
    "a" => "Artist",
    "g" => "Genre",
    "s" => "Setlist",
    "c" => "Songsheet",
    "t" => "Track",
    "u" => "User"
  }.freeze

  # Unique prefixed short id
  def uid
    ShortIdentifier.generate(self.class, id)
  end

  # Use uid in URL generation
  def to_param
    uid
  end

  class_methods do
    def find_by_uid(uid)
      find ShortUUID.expand(uid[1..])
    end
  end

  def self.generate(type, id)
    prefix = PREFIXES.invert.fetch(type.to_s)
    short_id = ShortUUID.shorten(id)
    "#{prefix}#{short_id}"
  end

  def self.locate(uid)
    type = PREFIXES[uid.to_s[0]].constantize
    type.find_by_uid(uid)
  end
end
