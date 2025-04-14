class TripsController < ApplicationController
  before_action :set_trip, only: %i[ show edit update destroy ]

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
        format.html { redirect_to @trip, notice: "Trip was successfully created." }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @trip = Trip.find_by(params[:id])
    @participants = @trip.participants
  end

  # PATCH/PUT /trips/1 or /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: "Trip was successfully updated." }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1 or /trips/1.json
  def destroy
    @trip = Trip.find(params[:id])
    @trip.participants.each do |participant|
      participant.expenses.each do |expense|
        expense.shared_participants.each do |shared_participant|
          expense.shared_participants.delete(shared_participant)
        end
        expense.destroy
      end
    end
    @trip.participants.destroy_all
    @trip.expenses.destroy_all
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: "Trip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find_by(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def trip_params
      params.expect(trip: [ :name, :start_date, :end_date ])
    end
end
