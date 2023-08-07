class TripsController < ApplicationController
  before_action :set_trip, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:submit_location, :update_status] # to skip authenticity token verification

  # GET /trips or /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1 or /trips/1.json
  def show
  end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips or /trips.json
  def create
    @trip = Trip.new(trip_params)

    respond_to do |format|
      if @trip.save
        format.html { redirect_to trip_url(@trip), notice: "Trip was successfully created." }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1 or /trips/1.json
  def update
    trip_status_index = Trip::STATUSES.index(@trip.status)
    new_status_index = Trip::STATUSES.index(trip_params[:status])

    if trip_params[:status] == "completed" || @trip.status == "completed" || trip_status_index > new_status_index
      render json: { error: "Trip status cannot be changed to or from completed or a step backward." }, status: :unprocessable_entity 
    else
      respond_to do |format|
        if @trip.update(trip_params)
          format.html { redirect_to trip_url(@trip), notice: "Trip was successfully updated." }
          format.json { render :show, status: :ok, location: @trip }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @trip.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /trips/1 or /trips/1.json
  def destroy
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to trips_url, notice: "Trip was successfully destroyed." }
      format.json { head :no_content, status: :ok }
    end
  end

  def update_status
    params = status_params
    trip = Trip.find(params[:id])
    current_status_index = Trip::STATUSES.index(trip.current_status)
    new_status_index = Trip::STATUSES.index(params[:status])

    if new_status_index.blank?
      render json: { error: "That's not a valid status." }, status: :unprocessable_entity 
    elsif current_status_index == new_status_index
      render json: { message: "Same Status"}, status: :ok
    elsif current_status_index > new_status_index
      render json: { error: "Trip status cannot be changed a step backward." }, status: :unprocessable_entity 
    else
      trip.update(params)
      render json: { message: "Status updated successfully!"}, status: :ok 
    end

  end

  def submit_location
    params = location_params
    trip = Trip.find(params[:id])

    if trip.status == "ongoing"
      location_diff_variable = 0.00083 # difference of 0.05 seconds between the last location and current location

      if (params[:latitude].blank? || params[:longitude].blank?) # Driver didn't send one of them
        render json: { error: "Longitude or Latitude can't be empty." }, status: :unprocessable_entity 
      # in this case if the driver is in the same position and didn't move or moved a little displacement no need to update specially the api is sent every 5 seconds
      elsif trip.locations.any? && ((trip.current_location[:longitude] - params[:longitude].to_f).abs < location_diff_variable && (trip.current_location[:latitude] - params[:latitude].to_f).abs < location_diff_variable)
        render json: { message: "Same Location"}, status: :ok  # successed but without updating cuz same location
      else
        # schedule job to be performed async
        TrackingJob.perform_async(params[:id].to_i,params[:latitude].to_f, params[:longitude].to_f)
        render json: { message: "Location updated successfully!"}, status: :ok 
      end
    elsif trip.status == "canceled"
      render json: { message: "Trip has been canceled"}, status: :ok
    else
      render json: { message: "Trip is already completed"}, status: :ok

    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trip_params
      params.require(:trip).permit(:status, :user_id, :vehicle_id, :current_longitude, :current_latitude)
    end

    def location_params
      params.permit(:id, :latitude, :longitude)
    end

    def status_params
      params.permit(:id, :status)
    end
end
