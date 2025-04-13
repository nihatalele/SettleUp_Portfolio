# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_13_211428) do
  create_table "expense_shares", force: :cascade do |t|
    t.integer "expense_id", null: false
    t.integer "participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_owed"
    t.index ["expense_id"], name: "index_expense_shares_on_expense_id"
    t.index ["participant_id"], name: "index_expense_shares_on_participant_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "description"
    t.decimal "amount"
    t.date "date"
    t.integer "participant_id", null: false
    t.integer "trip_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category"
    t.index ["participant_id"], name: "index_expenses_on_participant_id"
    t.index ["trip_id"], name: "index_expenses_on_trip_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "name"
    t.integer "trip_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_participants_on_trip_id"
  end

  create_table "test_enums", force: :cascade do |t|
    t.integer "thing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "expense_shares", "expenses"
  add_foreign_key "expense_shares", "participants"
  add_foreign_key "expenses", "participants"
  add_foreign_key "expenses", "trips"
  add_foreign_key "participants", "trips"
end
