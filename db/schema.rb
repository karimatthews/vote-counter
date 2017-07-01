# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170630110232) do

  create_table "ballots", force: :cascade do |t|
    t.integer "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["poll_id"], name: "index_ballots_on_poll_id"
  end

  create_table "options", force: :cascade do |t|
    t.integer "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["poll_id"], name: "index_options_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "title"
    t.string "voting_method"
    t.boolean "blind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ranks", force: :cascade do |t|
    t.integer "score"
    t.integer "ballot_id"
    t.integer "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ballot_id"], name: "index_ranks_on_ballot_id"
    t.index ["option_id"], name: "index_ranks_on_option_id"
  end

end
