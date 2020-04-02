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

ActiveRecord::Schema.define(version: 2020_03_31_173650) do

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", limit: 16777215
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "process_specimen_retrieval"
    t.boolean "process_sample_size"
    t.boolean "notify_when_all_specimens_released"
    t.boolean "display_patient_information"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "lab_honest_brokers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_lab_honest_brokers_on_group_id"
    t.index ["user_id"], name: "index_lab_honest_brokers_on_user_id"
  end

  create_table "labs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "patient_id"
    t.datetime "specimen_date"
    t.bigint "source_id"
    t.bigint "order_id"
    t.bigint "visit_id"
    t.bigint "lab_visit_id"
    t.string "accession_number", limit: 75
    t.boolean "removed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "Available"
    t.bigint "line_item_id"
    t.bigint "recipient_id"
    t.datetime "released_at"
    t.bigint "released_by"
    t.datetime "retrieved_at"
    t.datetime "discarded_at"
    t.index ["line_item_id"], name: "fk_rails_f32b2a1d2a"
    t.index ["patient_id"], name: "index_labs_on_patient_id"
    t.index ["released_by"], name: "index_labs_on_released_by"
    t.index ["source_id"], name: "index_labs_on_source_id"
  end

  create_table "line_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sparc_request_id"
    t.integer "service_id"
    t.integer "sparc_id"
    t.bigint "source_id"
    t.string "query_name"
    t.integer "query_count"
    t.string "minimum_sample_size"
    t.integer "number_of_specimens_requested"
    t.string "status"
    t.float "three_month_accrual"
    t.float "six_month_accrual"
    t.float "one_year_accrual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_line_items_on_source_id"
  end

  create_table "patients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "mrn"
    t.string "lastname"
    t.string "firstname"
    t.datetime "preference_date"
    t.string "contact_pref"
    t.string "bio_bank_pref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.date "dob"
  end

  create_table "populations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "patient_id"
    t.datetime "identified_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "line_item_id"
    t.index ["line_item_id"], name: "index_populations_on_line_item_id"
    t.index ["patient_id"], name: "index_populations_on_patient_id"
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id"
    t.integer "sparc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "sparc_id"], name: "index_services_on_group_id_and_sparc_id", unique: true
    t.index ["group_id"], name: "index_services_on_group_id"
  end

  create_table "sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id"
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "key"], name: "index_sources_on_group_id_and_key", unique: true
    t.index ["group_id"], name: "index_sources_on_group_id"
  end

  create_table "sparc_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status", default: "New"
    t.bigint "protocol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "submitted_at"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "net_id"
    t.boolean "admin"
    t.boolean "data_honest_broker", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id"
    t.integer "service_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "condition"
    t.index ["group_id", "name"], name: "index_variables_on_group_id_and_name", unique: true
    t.index ["group_id"], name: "index_variables_on_group_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "lab_honest_brokers", "groups"
  add_foreign_key "lab_honest_brokers", "users"
  add_foreign_key "labs", "line_items"
  add_foreign_key "labs", "patients"
  add_foreign_key "populations", "line_items"
  add_foreign_key "populations", "patients"
end
