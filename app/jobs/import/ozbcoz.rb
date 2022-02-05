require "throttle"
require "addressable"

# Import songs from https://ozbcoz.com/
class Import::Ozbcoz < Import::Chordpro
  include HTTParty
  base_uri "https://ozbcoz.com/"

  delegate :get, to: :class

  def perform(url)
    source = get(url).body.force_encoding("UTF-8")
    Import::Chordpro.perform_later source, songsheet: Songsheet.find_by(imported_from: url), imported_from: url
  end

  def self.all
    index_url = "/Songs/cp/index.php?instr=guitar"
    doc = Nokogiri::HTML(get(index_url).body)
    doc.css('a[href$=".pro"]').each do |a|
      perform_later Addressable::URI.join(base_uri, index_url, a["href"]).to_s
    end
  end
end
