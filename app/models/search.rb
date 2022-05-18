class Search
  MODELS = [Songsheet, Artist, Album, Track]
  MODEL_INCLUDES = {
    Songsheet => [{track: :album}],
    Album => [:artist],
    Track => [:artist, :album]
  }

  DEFAULTS = {
    models: MODELS,
    fields: ["everything^3", "title^2", "subtitle"],
    model_includes: MODEL_INCLUDES,
    boost_by: [:boost]
  }

  def initialize(query:, **options)
    @query = query
    @options = options
  end

  def results
    Searchkick.search(@query, **@options.with_defaults(DEFAULTS))
  end

  def self.reindex(*models, **args)
    models = MODELS if models.empty?
    models.each { |m| m.reindex(**args) }
  end
end
