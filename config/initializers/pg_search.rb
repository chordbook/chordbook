PgSearch.multisearch_options = {
  using: {
    tsearch: {
      dictionary: "english",
      tsvector_column: "content_tsv",
      prefix: true,
      normalization: 2
    },
    trigram: {}
  },
  ignoring: :accents,
  ranked_by: "((:trigram * .25) + (:tsearch * .75)) * weight"
}

# Otherwise AR overwrites this column to nil and the trigger doesn't work
PgSearch::Document.ignored_columns = ["content_tsv"]
