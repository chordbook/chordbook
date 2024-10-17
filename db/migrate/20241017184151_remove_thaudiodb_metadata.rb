class RemoveThaudiodbMetadata < ActiveRecord::Migration[7.1]
  def change
    %i[albums artists tracks].each do |table|
      remove_column table, :metadata
    end
  end
end
