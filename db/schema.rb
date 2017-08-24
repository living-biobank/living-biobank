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

ActiveRecord::Schema.define(version: 20170823134154) do

  create_table "i2b2_query_lists", force: :cascade do |t|
    t.text "query"
    t.string "query_name"
    t.integer "protocol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["protocol_id"], name: "index_i2b2_query_lists_on_protocol_id"
  end

  create_table "patient_hotlists", force: :cascade do |t|
    t.string "mrn"
    t.string "available_lab"
    t.datetime "date_matched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
