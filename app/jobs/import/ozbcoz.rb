require "throttle"
require "addressable"
require "chordpro"

class Chordpro::Song
  ALIASES = {
    't' => 'title',
    'st' => 'subtitle'
  }

  def directives
    elements.select { |e| e.is_a?(Chordpro::Directive) }
  end

  def metadata
    # FIXME: return enumerator
    directives.each_with_object({}) do |directive, result|
      key = ALIASES[directive.name] || directive.name
      result[key] = directive.value
    end
  end
end

module Chordpro
  def self.parse(input)
    Chordpro::Transform.new.apply(Chordpro::Parser.new.parse(input))
  end
end

class Import::Ozbcoz < ApplicationJob
  include HTTParty
  base_uri "https://ozbcoz.com/"

  delegate :get, to: :class

  class_attribute :throttle, default: Throttle.new(1.second)

  def perform(url)
    source = lint(get(url).body.force_encoding("UTF-8"))
    chordpro = Chordpro.parse(source)

    Songsheet.find_or_initialize_by(imported_from: url).tap do |s|
      s.source = source
      s.metadata = chordpro.metadata
      s.save!
    end
  end

  def self.all
    index_url = "/Songs/cp/index.php?instr=guitar"
    doc = Nokogiri::HTML(get(index_url).body)
    doc.css('a[href$=".pro"]').each do |a|
      perform_later Addressable::URI.join(base_uri, index_url, a["href"]).to_s
    end
  end

  def self.get(path, *args)
    throttle.call { super }
  end

  def lint(song)
    song.gsub('{c: }', "")
  end
end
