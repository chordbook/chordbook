module Viewable
  extend ActiveSupport::Concern

  included do
    scope :viewed, -> {
      joins(
        "JOIN (
          SELECT uuid(ahoy_events.properties->>'id') as record_id, user_id, MAX(time) AS time
          FROM ahoy_events
          WHERE name = 'view'
          GROUP BY record_id, user_id
        ) views ON views.record_id = #{table_name}.id"
      ).order("views.time DESC")
    }
    scope :viewed_by, ->(user) { viewed.where("views.user_id = ?", user) }
  end
end
