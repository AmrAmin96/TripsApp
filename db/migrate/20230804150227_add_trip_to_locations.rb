class AddTripToLocations < ActiveRecord::Migration[6.0]
  def change
    add_reference :locations, :trip, null: false, foreign_key: true
  end
end
