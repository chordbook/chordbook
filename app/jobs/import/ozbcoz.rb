require "throttle"
require "addressable"

# Import songs from https://ozbcoz.com/
class Import::Ozbcoz < Import::Chordpro
  include HTTParty
  base_uri "https://ozbcoz.com/"

  delegate :get, to: :class

  def perform(url)
    source = get(url).body.force_encoding("UTF-8")
    Import::Chordpro.perform_later lint(source), songsheet: Songsheet.find_by(imported_from: url), imported_from: url
  end

  ENDASH = "–"

  # Clean up Chordpro source
  def lint(source)
    source
      .gsub(/\s+$/, "") # trailing whitespace from each line
      .gsub(/{c:\s*}/, "") # Blank comments
      .gsub(/({\s*t(?:itle)?:)\s*(.*)(})/) do |match|
        prefix, suffix = $1, $3

        title = $2
          .gsub(/[\[(]\w{1,2}[\])]/, "") # Remove key, e.g. `[C]`, `(C)`, or `[Fm]`
          .gsub(/-?\s*Alt(?:ernative)?\s*$/i, "") # Remove ` - alt`
          .gsub(/(.*),\s*(A|An|The)\s*$/i) { [$2, $1].join(" ") } # Restore a/an/the to beginning of title
          .gsub(/ [-#{ENDASH}].*/o, "") # Remove any other `- anything`
        prefix + title + suffix
      end
  end

  def self.all
    index_url = "/Songs/cp/index.php?instr=guitar"
    doc = Nokogiri::HTML(get(index_url).body)
    doc.css('a[href$=".pro"]').each do |a|
      perform_later Addressable::URI.join(base_uri, index_url, a["href"]).to_s
    end
  end
end
