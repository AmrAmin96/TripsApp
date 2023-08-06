class ChangeColumnType < ActiveRecord::Migration[6.0]
  def up
    change_column :locations, :longitude, :float, using: 'longitude::float'
    change_column :locations, :latitude, :float, using: 'latitude::float'

  end

  def down
    change_column :locations, :longitude, :string
    change_column :locations, :latitude, :string
  end
  
end
