PgSearch.multisearch_options = {
  using: {
    tsearch: {
      prefix: true,
      normalization: 2
    },
    trigram: {}
  },
  ignoring: :accents,
  ranked_by: "(:trigram + :tsearch) * weight"
}
