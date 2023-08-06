class AddLngAndLtdToTrip < ActiveRecord::Migration[6.0]
  def change
    add_column :trips, :current_longitude, :string
    add_column :trips, :current_latitude, :string
  end
end
