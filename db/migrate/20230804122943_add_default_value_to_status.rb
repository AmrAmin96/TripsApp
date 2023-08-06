class AddDefaultValueToStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default :trips, :status, from: nil, to: "pending"
  end
end
