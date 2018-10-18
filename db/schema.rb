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

ActiveRecord::Schema.define(version: 2018_10_15_050744) do

  create_table "activities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "assets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "file"
    t.string "assetable_type"
    t.integer "assetable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "serializes"
    t.index ["assetable_type", "assetable_id"], name: "index_assets_on_assetable_type_and_assetable_id"
  end

  create_table "brokers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "store_id"
    t.string "department"
    t.string "person_type"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "irs_id"
    t.string "company"
    t.text "serializes"
    t.string "state"
    t.datetime "approved_at"
    t.index ["store_id"], name: "index_brokers_on_store_id"
  end

  create_table "builds", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.integer "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "information"
    t.integer "position"
    t.index ["store_id"], name: "index_builds_on_store_id"
  end

  create_table "buyers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "information"
    t.integer "store_id"
    t.integer "proposal_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id"], name: "index_buyers_on_proposal_id"
    t.index ["store_id"], name: "index_buyers_on_store_id"
  end

  create_table "dashboards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.datetime "approved_at"
    t.integer "proposal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "documentable_type"
    t.bigint "documentable_id"
    t.string "kind"
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id"
    t.index ["proposal_id"], name: "index_documents_on_proposal_id"
  end

  create_table "finances_accounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "contra", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "type"], name: "index_finances_accounts_on_name_and_type"
  end

  create_table "finances_amounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "index_finances_amounts_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_finances_amounts_on_account_id"
    t.index ["entry_id", "account_id"], name: "index_finances_amounts_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_finances_amounts_on_entry_id"
    t.index ["type"], name: "index_finances_amounts_on_type"
  end

  create_table "finances_entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.integer "commercial_document_id"
    t.string "commercial_document_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc"
    t.index ["date"], name: "index_finances_entries_on_date"
  end

  create_table "finances_invoices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "invoiceable_type"
    t.integer "invoiceable_id"
    t.decimal "amount", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoiceable_id", "invoiceable_type"], name: "index_finances_invoices_on_invoiceable_id_and_invoiceable_type"
    t.index ["invoiceable_type", "invoiceable_id"], name: "index_finances_invoices_on_invoiceable_type_and_invoiceable_id"
  end

  create_table "mailer_senders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "to"
    t.string "token"
    t.text "information"
    t.bigint "mailer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "send_at"
    t.index ["mailer_id"], name: "index_mailer_senders_on_mailer_id"
  end

  create_table "mailers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "parameters"
    t.integer "store_id"
    t.string "userable_type"
    t.integer "userable_id"
    t.string "mailable_type"
    t.integer "mailable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "owner_id"
    t.index ["mailable_type", "mailable_id"], name: "index_mailers_on_mailable_type_and_mailable_id"
    t.index ["store_id"], name: "index_mailers_on_store_id"
    t.index ["userable_type", "userable_id"], name: "index_mailers_on_userable_type_and_userable_id"
  end

  create_table "notes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "information"
    t.bigint "proposal_id"
    t.bigint "unit_id"
    t.bigint "broker_id"
    t.bigint "admin_id"
    t.boolean "intern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_notes_on_admin_id"
    t.index ["broker_id"], name: "index_notes_on_broker_id"
    t.index ["proposal_id"], name: "index_notes_on_proposal_id"
    t.index ["unit_id"], name: "index_notes_on_unit_id"
  end

  create_table "notifies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "notiable_type"
    t.bigint "notiable_id"
    t.text "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notiable_type", "notiable_id"], name: "index_notifies_on_notiable_type_and_notiable_id"
  end

  create_table "persons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "store_id"
    t.string "irs_id"
    t.string "department"
    t.string "person_type"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_persons_on_store_id"
  end

  create_table "proposals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "state"
    t.text "information"
    t.integer "unit_id"
    t.integer "broker_id"
    t.date "due_at"
    t.date "booked_at"
    t.date "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["broker_id"], name: "index_proposals_on_broker_id"
    t.index ["unit_id"], name: "index_proposals_on_unit_id"
  end

  create_table "stores", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "settings"
    t.datetime "disabled_at"
    t.datetime "term_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "units", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "information"
    t.decimal "value", precision: 10, scale: 2
    t.decimal "size", precision: 10, scale: 2
    t.decimal "brokerage", precision: 10, scale: 2, default: "5.0"
    t.integer "build_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "pending"
    t.index ["build_id"], name: "index_units_on_build_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
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
    t.string "userable_type"
    t.integer "userable_id"
    t.integer "store_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["userable_type", "userable_id"], name: "index_users_on_userable_type_and_userable_id"
  end

  add_foreign_key "buyers", "proposals"
  add_foreign_key "units", "builds"
end
