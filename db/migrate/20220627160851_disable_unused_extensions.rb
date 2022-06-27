class DisableUnusedExtensions < ActiveRecord::Migration[7.0]
  def change
    disable_extension "pg_trgm"
    disable_extension "plpgsql"
    disable_extension "unaccent"
  end
end
