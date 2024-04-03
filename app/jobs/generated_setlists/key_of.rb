class GeneratedSetlists::KeyOf < GeneratedSetlists
  def perform
    %w[A A#/Bb B C C#/Db D D#/Eb E F F#/Gb G G#/Ab].each do |key|
      keys = key.split("/")
      update_setlist "Key of #{key}" do
        Songsheet.where("metadata->>'key' IN (?)", keys).order_by_popular
      end

      # Minor
      keys = keys.map { |k| "#{k}m" }
      update_setlist "Key of #{keys.join("/")}" do
        Songsheet.where("metadata->>'key' IN (?)", keys).order_by_popular
      end
    end
  end
end
