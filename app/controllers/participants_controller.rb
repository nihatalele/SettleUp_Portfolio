class ParticipantsController < ApplicationController
  before_action :set_trip

  def new
    @participant = @trip.participants.build
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @participant = @trip.participants.find(params[:id])
  end

  def edit
  end

  def create
    @participant = @trip.participants.build(participant_params)
    if @participant.save
      redirect_to edit_trip_path(@trip), notice: 'Participant was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /trips/1 or /trips/1.json
  def update
    respond_to do |format|
      if @participant.update(trip_params)
        format.html { redirect_to @participant, notice: "Participant was successfully updated." }
        format.json { render :show, status: :ok, location: @Participant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @Participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trip = Trip.find(params[:trip_id])
    @participant = @trip.participants.find(params[:id])
    @participant.destroy
    redirect_to trip_path(@trip), notice: "Participant was successfully removed."
  end


  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def participant_params
    params.require(:participant).permit(:name)
  end
end