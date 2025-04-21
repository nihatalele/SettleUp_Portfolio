# app/controllers/expenses_controller.rb
class ExpensesController < ApplicationController
  # Ensure a user is signed in before any action
  before_action :authenticate_user!

  # Load only trips the user owns or is invited to via email
  before_action :set_trip

  # Enforce authorization on all actions that view or modify a trip’s data
  before_action only: %i[new create show edit update destroy] do
    authorize_trip!(@trip)
  end

  # Load the participant within the scoped trip
  before_action :set_participant

  # Load the specific expense for show/edit/update/destroy
  before_action :set_expense, only: %i[show edit update destroy]

  # GET /trips/:trip_id/participants/:participant_id/expenses/new
  # Prepare a blank Expense for the “new” form
  def new
    @expense = @participant.expenses.build
  end

  # POST /trips/:trip_id/participants/:participant_id/expenses
  # Create a new expense and calculate shares
  def create
    @expense      = @participant.expenses.build(expense_params)
    @expense.trip = @trip

    if @expense.save
      # Distribute the expense among checked participants
      @expense.calculate_shares
      redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense added."
    else
      render :new
    end
  end

  # GET /trips/:trip_id/participants/:participant_id/expenses/:id/edit
  # Renders the edit form (expense is already loaded)
  def edit
  end

  # PATCH/PUT /trips/:trip_id/participants/:participant_id/expenses/:id
  # Update the expense and recalculate shares
  def update
    if @expense.update(expense_params)
      @expense.calculate_shares
      redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense updated."
    else
      render :edit
    end
  end

  # DELETE /trips/:trip_id/participants/:participant_id/expenses/:id
  # Remove the expense and its share links
  def destroy
    @expense.shared_participants.clear
    @expense.destroy
    redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense was successfully deleted."
  end

  private

  # Finds the trip scoped to current_user or invited by email
  def set_trip
    @trip = Trip.for_user(current_user).find(params[:trip_id])
  end

  # Finds the participant belonging to the loaded trip
  def set_participant
    @participant = @trip.participants.find(params[:participant_id])
  end

  # Finds the expense belonging to the loaded participant
  def set_expense
    @expense = @participant.expenses.find(params[:id])
  end

  # Strong parameters: permit only these attributes from the form
  def expense_params
    params.require(:expense)
          .permit(
            :description,
            :amount,
            :date,
            :currency,
            :category,
            :participant_id,
            shared_participant_ids: []
          )
  end
end
