# app/controllers/participants_controller.rb
class ParticipantsController < ApplicationController
  # Ensure only signed‑in users can access any participant actions
  before_action :authenticate_user!

  # Load only trips the user owns or is invited to via email
  before_action :set_trip

  # Enforce authorization for all nested participant actions
  before_action only: %i[new create show edit update destroy] do
    authorize_trip!(@trip)
  end

  # Load the specific participant for show/edit/update/destroy
  before_action :set_participant, only: %i[show edit update destroy]

  # GET /trips/:trip_id/participants/new
  # Prepare a new Participant for the form
  def new
    @participant = @trip.participants.build
  end

  # POST /trips/:trip_id/participants
  # Create a participant and redirect or re‑render on failure
  def create
    @participant = @trip.participants.build(participant_params)
    if @participant.save
      redirect_to edit_trip_path(@trip), notice: "Participant was successfully created."
    else
      render :new
    end
  end

  # GET /trips/:trip_id/participants/:id
  # Display summary data for this participant
  def show
    @total_spent  = @participant.total_spent
    @total_owed   = @participant.total_owed
    @owes_to_each = @participant.owes_to_each
  end

  # GET /trips/:trip_id/participants/:id/edit
  # Renders the edit form (participant is already loaded)
  def edit
  end

  # PATCH/PUT /trips/:trip_id/participants/:id
  # Update participant attributes or re‑render on failure
  def update
    if @participant.update(participant_params)
      redirect_to trip_participant_path(@trip, @participant), notice: "Participant was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /trips/:trip_id/participants/:id
  # Remove participant and associated expenses/shares
  def destroy
    @participant.expenses.each do |expense|
      expense.shared_participants.clear
      expense.destroy
    end
    @participant.destroy
    redirect_to edit_trip_path(@trip), notice: "Participant was successfully removed."
  end

  private

  # Finds the trip scoped to current_user or invited by email
  def set_trip
    @trip = Trip.for_user(current_user).find(params[:trip_id])
  end

  # Finds the participant belonging to the loaded trip
  def set_participant
    @participant = @trip.participants.find(params[:id])
  end

  # Strong parameters: permit only name and email
  def participant_params
    params.require(:participant).permit(:name, :email)
  end
end
