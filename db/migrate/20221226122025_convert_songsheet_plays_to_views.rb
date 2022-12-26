class ConvertSongsheetPlaysToViews < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      UPDATE ahoy_events SET
        name = 'view',
        properties = jsonb_build_object('id', properties->>'songsheet_id', 'action', 'show', 'type', 'Songsheet')
      WHERE name = 'play';
    SQL
  end
end
