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

ActiveRecord::Schema.define(version: 20181126172407) do

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "labs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "patient_id"
    t.datetime "specimen_date"
    t.bigint "order_id"
    t.bigint "visit_id"
    t.bigint "lab_visit_id"
    t.string "accession_number", limit: 75, collation: "utf8_general_ci"
    t.string "specimen_source", collation: "utf8_general_ci"
    t.boolean "removed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_labs_on_patient_id"
  end

  create_table "patients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "mrn", collation: "utf8_general_ci"
    t.string "lastname"
    t.string "firstname"
    t.datetime "preference_date"
    t.string "contact_pref", collation: "utf8_general_ci"
    t.string "bio_bank_pref", collation: "utf8_general_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "populations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "sparc_request_id"
    t.bigint "patient_id"
    t.datetime "identified_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_populations_on_patient_id"
    t.index ["sparc_request_id"], name: "index_populations_on_sparc_request_id"
  end

  create_table "sparc_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "user_id"
    t.string "short_title", collation: "utf8_general_ci"
    t.text "title", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.string "funding_status", collation: "utf8_general_ci"
    t.string "funding_source", collation: "utf8_general_ci"
    t.date "start_date"
    t.date "end_date"
    t.string "primary_pi_netid", collation: "utf8_general_ci"
    t.string "primary_pi_name", collation: "utf8_general_ci"
    t.string "primary_pi_email", collation: "utf8_general_ci"
    t.string "query_name", collation: "utf8_general_ci"
    t.string "service_source", collation: "utf8_general_ci"
    t.bigint "service_id"
    t.string "time_estimate", collation: "utf8_general_ci"
    t.string "status", default: "New", collation: "utf8_general_ci"
    t.bigint "protocol_id"
    t.bigint "line_item_id"
    t.string "minimum_sample_size", collation: "utf8_general_ci"
    t.integer "number_of_specimens_requested"
    t.integer "query_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "protocol_id"
    t.datetime "release_date"
    t.string "release_to", collation: "utf8_general_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.string "mrn", collation: "utf8_general_ci"
    t.string "service_source", collation: "utf8_general_ci"
    t.bigint "service_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "first_name", collation: "utf8_general_ci"
    t.string "last_name", collation: "utf8_general_ci"
    t.string "email", default: "", null: false, collation: "utf8_general_ci"
    t.string "net_id", collation: "utf8_general_ci"
    t.boolean "honest_broker", default: false
    t.string "encrypted_password", default: "", null: false, collation: "utf8_general_ci"
    t.string "reset_password_token", collation: "utf8_general_ci"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", collation: "utf8_general_ci"
    t.string "last_sign_in_ip", collation: "utf8_general_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "labs", "patients"
  add_foreign_key "populations", "patients"
  add_foreign_key "populations", "sparc_requests"
end
