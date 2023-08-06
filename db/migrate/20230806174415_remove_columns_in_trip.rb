class RemoveColumnsInTrip < ActiveRecord::Migration[6.0]
  def change
    remove_column :trips, :current_longitude, :string
    remove_column :trips, :current_latitude, :string
  end
end
