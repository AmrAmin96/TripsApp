class TrackingJob
  include Sidekiq::Worker
  sidekiq_options queue: 'tracking'

  def perform *args
    id , lat , long = args
    trip = Trip.find(id)
    location = trip.locations.build(longitude: long, latitude: lat)
    location.save
  end
end

