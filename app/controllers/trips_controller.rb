# app/controllers/trips_controller.rb
class TripsController < ApplicationController
  # Require the user to be signed in before any action
  before_action :authenticate_user!

  # Load the trip (scoped to owner or invited by email) for these actions
  before_action :set_trip, only: %i[show edit update destroy]

  # Enforce that only authorized users (owner or email‑invitee) can access these actions
  before_action only: %i[show edit update destroy] do
    authorize_trip!(@trip)
  end

  # GET /trips
  # List all trips the user owns or has been invited to
  def index
    @trips = Trip.for_user(current_user)
  end

  # GET /trips/new
  # Prepare a new Trip for the form
  def new
    @trip = current_user.trips.build
  end

  # POST /trips
  # Create a new Trip associated with the current_user
  def create
    @trip = current_user.trips.build(trip_params)
    if @trip.save
      redirect_to @trip, notice: "Trip was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /trips/:id
  # Show the Trip and its participants
  def show
    @participants = @trip.participants
  end

  # GET /trips/:id/edit
  # Renders the edit form for the Trip (already loaded)
  def edit
  end

  # PATCH/PUT /trips/:id
  # Update the Trip or re-render the form on failure
  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: "Trip was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /trips/:id
  # Destroy the Trip and all dependent records, then redirect
  def destroy
    # re‑scope to ensure proper access
    @trip = Trip.for_user(current_user).find(params[:id])
    @trip.destroy
    redirect_to trips_path, notice: "Trip was successfully destroyed."
  end

  private

  # Finds the Trip scoped to current_user or those invited by email
  def set_trip
    @trip = Trip.for_user(current_user).find(params[:id])
  end

  # Whitelist the permitted parameters for Trip
  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :currency)
  end
end
