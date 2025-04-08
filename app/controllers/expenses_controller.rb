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
      redirect_to trip_path(@participant.trip), notice: "Expense updated."
    else
      render :edit
    end
  end

  def destroy
    @expense.destroy
    redirect_to trip_path(@participant.trip), notice: "Expense deleted."
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_participant
    @participant = Participant.find(params[:participant_id])
  end

  def set_expense
    @expense = @participant.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :date, :participant_id, shared_participant_ids: [])
  end  
end
