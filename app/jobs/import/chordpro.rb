require "chordpro"

# Import a songsheet in chordpro format
class Import::Chordpro < ApplicationJob
  def perform(source, songsheet: nil, **attrs)
    source = lint(source)
    chordpro = Chordpro.parse(source)

    (songsheet || Songsheet.new).tap do |s|
      s.assign_attributes attrs.merge(source: source, metadata: chordpro.metadata)
      s.save!
    end
  end

  # Clean up Chordpro source
  def lint(source)
    source
      .gsub(/\s+$/, "") # trailing whitespace from each line
      .gsub("{c: }", "") # Blank comments
  end
end

## FIXME: move these into chordpro gem
class Chordpro::Song
  ALIASES = {
    "t" => "title",
    "st" => "subtitle"
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
