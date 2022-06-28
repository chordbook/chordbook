require "chordpro"

# Import a songsheet in chordpro format
class Import::Chordpro < ApplicationJob
  # Source needs modified
  discard_on ActiveRecord::RecordInvalid

  def perform(source, songsheet: nil, **attrs)
    chordpro = Chordpro.parse(source.strip)

    # Don't index yet, let the metadata lookup job do that
    Searchkick.callbacks(false) do
      (songsheet || Songsheet.new).tap do |s|
        s.assign_attributes attrs.merge(source: source, metadata: chordpro.metadata.to_h)
        s.save!
      end
    end
  end
end
