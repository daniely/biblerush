# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_10_173954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reading_plan_details", force: :cascade do |t|
    t.integer "reading_plan_id"
    t.text "reference"
    t.text "detailed_reference"
    t.integer "day"
    t.text "passages", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reading_plan_id", "day"], name: "index_reading_plan_details_on_reading_plan_id_and_day"
    t.index ["reading_plan_id"], name: "index_reading_plan_details_on_reading_plan_id"
  end

  create_table "reading_plans", force: :cascade do |t|
    t.text "plan_name"
    t.text "description"
    t.integer "days"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_name"], name: "index_reading_plans_on_plan_name"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reading_plan_id"
    t.integer "day"
    t.datetime "read_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day"], name: "index_subscriptions_on_day"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

end
