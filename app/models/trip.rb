class Trip < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle
  has_many :locations

  STATUSES = %w(pending confirmed ongoing completed canceled)
  validates :status, inclusion: { in: STATUSES }


  def current_location
    Rails.cache.fetch("#{cache_key_with_version}/current_location", expires_in: 12.hours) do
      lng = self.locations.last.longitude
      lat = self.locations.last.latitude  
      {longitude: lng, latitude: lat}
    end
  end

  def current_status
    Rails.cache.fetch("#{cache_key_with_version}/current_status", expires_in: 12.hours) do
      self.status
    end
  end


  def location_history
    self.locations
  end

end
