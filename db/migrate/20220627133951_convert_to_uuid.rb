class ConvertToUuid < ActiveRecord::Migration[7.0]
  TABLES = {
    access_tokens: [:user_id],
    ahoy_events: [:visit_id, :user_id],
    ahoy_visits: [:user_id],
    albums: [:artist_id, :genre_id],
    artist_works: [:artist_id, :work_id],
    artists: [:genre_id],
    genres: [],
    library_items: [:user_id, :item_id],
    mailkick_subscriptions: [:subscriber_id],
    setlist_items: [:setlist_id, :songsheet_id],
    setlists: [:user_id],
    songsheets: [:track_id],
    tracks: [:artist_id, :album_id, :genre_id],
    users: [],
    versions: [:item_id]
  }

  TABLE_ALIASES = {
    "visits" => "ahoy_visits"
  }

  def change
    # Delete versions for old model
    execute "DELETE FROM versions WHERE item_type = 'Medium'"

    # Ensure UUIDs are enabled
    enable_extension :pgcrypto

    # Add UUID primary keys
    TABLES.each do |table, _|
      add_column table, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    end

    # Add UUID foreign keys
    TABLES.each do |table, foreign_keys|
      foreign_keys.each do |foreign_key|
        uuid_foreign_key = foreign_key.to_s.sub("_id", "_uuid")
        foreign_table = foreign_key.to_s.sub("_id", "").pluralize
        foreign_table = TABLE_ALIASES[foreign_table] || foreign_table

        add_column table, uuid_foreign_key, :uuid

        # Populate UUID columns for associations
        polymorphic_column = foreign_key.to_s.sub("_id", "_type")
        is_polymorphic = column_exists?(table, polymorphic_column)
        if is_polymorphic
          # Update each type separately for polymorphic table
          select_values("SELECT DISTINCT #{polymorphic_column} from #{table}").each do |type|
            polymorphic_table = type.underscore.pluralize
            execute <<-SQL
              UPDATE #{table} SET #{uuid_foreign_key} = #{polymorphic_table}.uuid
              FROM #{polymorphic_table} WHERE #{table}.#{foreign_key} = #{polymorphic_table}.id
              AND #{table}.#{polymorphic_column} = '#{type}';
            SQL
          end
        else
          execute <<-SQL
            UPDATE #{table} SET #{uuid_foreign_key} = #{foreign_table}.uuid
            FROM #{foreign_table} WHERE #{table}.#{foreign_key} = #{foreign_table}.id;
          SQL
        end

        # Delete orphaned records if column requires a value
        column = columns(table).detect { |c| c.name == foreign_key.to_s }
        execute "DELETE FROM #{table} WHERE #{uuid_foreign_key} IS NULL" unless column.null
        # Change null
        change_column_null table, uuid_foreign_key, false unless column.null

        # Save list of indexes
        indexes_to_define = indexes(table).select { |i| Array(i.columns).include?(foreign_key.to_s) }

        # Remove bigint foreign keys
        remove_column table, foreign_key
        rename_column table, uuid_foreign_key, foreign_key

        # Restore indexes for associations
        indexes_to_define.each do |index|
          add_index(index.table, index.columns,
            name: index.name,
            type: index.type,
            unique: index.unique,
            opclass: index.opclasses,
            where: index.where,
            using: index.using)
        end
      end
    end

    # Migrate primary keys from UUIDs to IDs
    TABLES.keys.each do |table|
      remove_column table, :id
      rename_column table, :uuid, :id
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id)"
    end

    # Add foreign keys
    TABLES.each do |table, foreign_keys|
      foreign_keys.each do |foreign_key|
        is_polymorphic = column_exists?(table, foreign_key.to_s.sub("_id", "_type"))
        unless is_polymorphic
          foreign_table = foreign_key.to_s.sub("_id", "").pluralize
          foreign_table = TABLE_ALIASES[foreign_table] || foreign_table
          add_foreign_key table, foreign_table, column: foreign_key
        end
      end
    end
  end
end
