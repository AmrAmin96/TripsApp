class ChangeColumnNameOfVehicleType < ActiveRecord::Migration[6.0]
  def change
    rename_column :vehicles, :type, :vehicle_type

  end
end
