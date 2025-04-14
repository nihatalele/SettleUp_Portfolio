class ExpensesController < ApplicationController
  before_action :set_trip
  before_action :set_participant
  before_action :set_expense, only: %i[show edit update destroy]

  def new
    @expense = @participant.expenses.build
  end

  def create
    @expense = @participant.expenses.build(expense_params)
    @expense.trip = @trip

    if @expense.save
      # Call the calculate_shares method to distribute the expense among participants.
      @expense.calculate_shares
      redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense added."
    else
      render :new
    end
  end

  def edit
    @trip = @expense.trip
  end

  def update
    if @expense.update(expense_params)
      # Call the calculate_shares method to redistribute the expense among participants.
      @expense.calculate_shares
      redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense updated."
    else
      render :edit
    end
  end

  def destroy
    @expense.shared_participants.each do |shared_participant|
      @expense.shared_participants.delete(shared_participant)
    end
    @expense.destroy
    redirect_to trip_participant_expense_path(@trip, @participant), notice: "Expense deleted."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_participant
    @participant = Participant.find(params[:participant_id])
  end

  def set_expense
    # Find the expense using the participant's expenses association
    # This ensures that the expense belongs to the correct participant.
    # This is important for security reasons, as we don't want to expose expenses
    # that don't belong to the participant.

    # @expense = Expense.find(params[:id])
    # @expense = @trip.expenses.find(params[:id])
    # @expense = @trip.expenses.find_by(id: params[:id], participant_id: @participant.id)
    # @expense = @trip.expenses.find_by(id: params[:id], participant_id: @participant.id)
    @expense = @participant.expenses.find_by(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :category, :participant_id, shared_participant_ids: [])
  end
end
