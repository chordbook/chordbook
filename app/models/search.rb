class Search
  MODELS = [Songsheet, Artist, Album, Track]
  MODEL_INCLUDES = {
    Songsheet => [{track: :album}],
    Album => [:artist],
    Track => [:artist, :album]
  }

  DEFAULTS = {
    models: MODELS,
    fields: ["everything^4", "title^3", "artist^2", "album"],
    model_includes: MODEL_INCLUDES,
    boost_by: [:boost]
  }

  def initialize(query:, **options)
    @query = query
    @options = options
  end

  def results
    Searchkick.search(@query, **@options.with_defaults(DEFAULTS))
    # Searchkick.search({
    #   body: {
    #   query: {
    #     multi_match: {
    #       query: @query,
    #       type: "cross_fields",
    #       fields: [
    #         "title^3",
    #         "artist^2",
    #         "album"
    #       ]
    #     }
    #   }
    # }}, models: MODELS)
  end

  def self.reindex(*models, **args)
    models = MODELS if models.empty?
    models.each { |m| m.reindex(**args) }
  end
end
