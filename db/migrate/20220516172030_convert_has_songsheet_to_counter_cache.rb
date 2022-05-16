class ConvertHasSongsheetToCounterCache < ActiveRecord::Migration[7.0]
  def change
    change_table :tracks do |t|
      t.integer :songsheets_count, default: 0
      t.remove :has_songsheet, type: :boolean
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
          with c as (
            select track_id, count(*) as count
            from songsheets
            group by track_id
          )
          update tracks
          set songsheets_count = c.count
          from c
          where tracks.id = c.track_id;
        SQL
      end
    end
  end
end
