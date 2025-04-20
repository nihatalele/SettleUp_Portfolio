# app/controllers/participants_controller.rb
class ParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip
  before_action only: %i[new create show edit update destroy] do
    authorize_trip!(@trip)
  end
  before_action :set_participant, only: %i[show edit update destroy]

  # GET /trips/:trip_id/participants/new
  def new
    @participant = @trip.participants.build
  end

  # POST /trips/:trip_id/participants
  def create
    @participant = @trip.participants.build(participant_params)
    if @participant.save
      redirect_to edit_trip_path(@trip), notice: "Participant was successfully created."
    else
      render :new
    end
  end

  # GET /trips/:trip_id/participants/:id
  def show
    @total_spent  = @participant.total_spent
    @total_owed   = @participant.total_owed
    @owes_to_each = @participant.owes_to_each
  end

  # GET /trips/:trip_id/participants/:id/edit
  def edit
  end

  # PATCH/PUT /trips/:trip_id/participants/:id
  def update
    if @participant.update(participant_params)
      redirect_to trip_participant_path(@trip, @participant), notice: "Participant was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /trips/:trip_id/participants/:id
  def destroy
    @participant.expenses.each { |e| e.shared_participants.clear; e.destroy }
    @participant.destroy
    redirect_to edit_trip_path(@trip), notice: "Participant was successfully removed."
  end

  private

  def set_trip
    @trip = Trip.for_user(current_user).find(params[:trip_id])
  end

  def set_participant
    @participant = @trip.participants.find(params[:id])
  end

  def participant_params
    params.require(:participant).permit(:name, :email)
  end
end
