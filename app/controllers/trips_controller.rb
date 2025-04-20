# app/controllers/trips_controller.rb
class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: %i[show edit update destroy]
  before_action only: %i[show edit update destroy] do
    authorize_trip!(@trip)
  end

  # GET /trips
  def index
    @trips = Trip.for_user(current_user)
  end

  # GET /trips/new
  def new
    @trip = current_user.trips.build
  end

  # POST /trips
  def create
    @trip = current_user.trips.build(trip_params)
    if @trip.save
      redirect_to @trip, notice: "Trip was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /trips/:id
  def show
    @participants = @trip.participants
  end

  # GET /trips/:id/edit
  def edit
  end

  # PATCH/PUT /trips/:id
  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: "Trip was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /trips/:id
  def destroy
    @trip = Trip.for_user(current_user).find(params[:id])
    @trip.destroy
    redirect_to trips_path, notice: "Trip was successfully destroyed."
  end

  private

  def set_trip
    @trip = Trip.for_user(current_user).find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :currency)
  end
end
