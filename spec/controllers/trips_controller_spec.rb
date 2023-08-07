# spec/controllers/trips_controller_spec.rb
require 'rails_helper'
require 'factory_bot_rails'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  # Other RSpec configurations
end

RSpec.describe TripsController, type: :controller do
  describe '#submit_location' do
    let(:user) { create(:user) }
    let(:vehicle) { create(:vehicle) }
    let(:trip) { create(:trip, status: status, user: user, vehicle: vehicle) }
    let(:location) { create(:location, longitude: 128.0, latitude: 79.0, trip: trip) }

    let(:location_diff_variable) { 0.00083 }
    let(:params) { { id: trip.id, latitude: new_latitude, longitude: new_longitude } }

    before { allow(Trip).to receive(:find).and_return(trip) }
    before { allow(Location).to receive(:find).and_return(location) }

    context 'when the trip status is ongoing' do
      let(:status) { 'ongoing' }

      context 'when latitude or longitude is missing' do
        let(:new_latitude) { nil }
        let(:new_longitude) { 123 }

        it 'returns an error response' do
          post :submit_location, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq({ "error" => "Longitude or Latitude can't be empty." })
        end
      end

      context 'when the location has not changed' do
        let(:new_latitude) { 79.0 }
        let(:new_longitude) { 128.0 }


        it 'returns a success response without updating the location' do
          post :submit_location, params: params
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({ "message" => "Same Location" })
        end
      end

      context 'when the location has changed' do
        let(:new_latitude) { 123.0 }
        let(:new_longitude) { 456.0 }

        it 'schedules a job and returns a success response' do
          expect(TrackingJob).to receive(:perform_async).with(trip.id, new_latitude, new_longitude)
          post :submit_location, params: params
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({ "message" => "Location updated successfully!" })
        end
      end
    end

    context 'when the trip status is canceled' do
      let(:status) { 'canceled' }
      let(:new_latitude) { 123 }
      let(:new_longitude) { 456 }

      it 'returns a response indicating the trip has been canceled' do
        post :submit_location, params: params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "message" => "Trip has been canceled" })
      end
    end

    context 'when the trip status is completed' do
      let(:status) { 'completed' }
      let(:new_latitude) { 123 }
      let(:new_longitude) { 456 }

      it 'returns a response indicating the trip is already completed' do
        post :submit_location, params: params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "message" => "Trip is already completed" })
      end
    end
  end
end
