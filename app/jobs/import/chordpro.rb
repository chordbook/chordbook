require "chordpro"

# Import a songsheet in chordpro format
class Import::Chordpro < ApplicationJob
  def perform(source, songsheet: nil, **attrs)
    source = lint(source)
    chordpro = Chordpro.parse(source)

    (songsheet || Songsheet.new).tap do |s|
      s.assign_attributes attrs.merge(source: source, metadata: chordpro.metadata.to_h)
      s.save!
    end
  end

  # Clean up Chordpro source
  def lint(source)
    source
      .gsub(/\s+$/, "") # trailing whitespace from each line
      .gsub(/{c:\s*}/, "") # Blank comments
  end
end
