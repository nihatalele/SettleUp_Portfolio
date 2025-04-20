# app/controllers/expenses_controller.rb
class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip
  before_action only: %i[new create show edit update destroy] do
    authorize_trip!(@trip)
  end
  before_action :set_participant
  before_action :set_expense, only: %i[show edit update destroy]

  # GET /trips/:trip_id/participants/:participant_id/expenses/new
  def new
    @expense = @participant.expenses.build
  end

  # POST /trips/:trip_id/participants/:participant_id/expenses
  def create
    @expense            = @participant.expenses.build(expense_params)
    @expense.trip       = @trip
    if @expense.save
      @expense.calculate_shares
      redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense added."
    else
      render :new
    end
  end

  # GET /trips/:trip_id/participants/:participant_id/expenses/:id/edit
  def edit
  end

  # PATCH/PUT /trips/:trip_id/participants/:participant_id/expenses/:id
  def update
    if @expense.update(expense_params)
      @expense.calculate_shares
      redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense updated."
    else
      render :edit
    end
  end

  # DELETE /trips/:trip_id/participants/:participant_id/expenses/:id
  def destroy
    @expense.shared_participants.clear
    @expense.destroy
    redirect_to trip_participant_expenses_path(@trip, @participant), notice: "Expense was successfully deleted."
  end

  private

  def set_trip
    @trip = Trip.for_user(current_user).find(params[:trip_id])
  end

  def set_participant
    @participant = @trip.participants.find(params[:participant_id])
  end

  def set_expense
    @expense = @participant.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense)
          .permit(:description,
                  :amount,
                  :date,
                  :currency,
                  :category,
                  :participant_id,
                  shared_participant_ids: [])
  end
end
