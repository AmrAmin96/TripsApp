# README

1 - User model with name and email
2 - Vehicle model with vehicle_type and number to allow different types of vehicles
3 - Trip model with status and user_id which is reference to user table and vehicle_id which is reference to vehicle table 
4 - Location model with longitude and latitude and trip_id which is referenceto trip table
5 - Trip controller with CRUD operations for trips
6 - Api for updating status of trip in one direction only
7 - Api for submit_location to update current location of the driver or of the trip 
8 - worker for updating current location usinng sidekiq
9 - caching current location and current status so that if they are not changed the cached value is returned without hitting the db 
10 - testing submit location api with all its cases using rspec unit test

Explaination:
In this code i generated the models where users has many trips and trip has only one user , same with vehicle 
while trips has many locations and locations has one trip . In the controllers i created crud operations for trip controller 
to get , edit, create, delete trips also an api to submit_status and another to submit_location
in submit location first I will change only if the last location and current location weere changed with time difference 0.05 seconds so that
if the driver is waiting in the same position i don't want to fill my table with the same records for the same trip
also if there is not a longitude or latitude sent and the trip must be in ongoing state
* ...
# TripsApp
