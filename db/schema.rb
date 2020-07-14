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

ActiveRecord::Schema.define(version: 2020_06_18_122324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.bigint "potential_action_id", null: false
    t.bigint "organisation_id"
    t.jsonb "details"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id"
    t.index ["organisation_id"], name: "index_actions_on_organisation_id"
    t.index ["person_id"], name: "index_actions_on_person_id"
    t.index ["potential_action_id"], name: "index_actions_on_potential_action_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "affiliations", force: :cascade do |t|
    t.bigint "individual_id", null: false
    t.bigint "organisation_id", null: false
    t.string "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "individual_type", default: "User", null: false
    t.index ["individual_id", "individual_type"], name: "index_affiliations_on_individual_id_and_individual_type"
    t.index ["individual_id"], name: "index_affiliations_on_individual_id"
    t.index ["organisation_id"], name: "index_affiliations_on_organisation_id"
  end

  create_table "charity_domain_lookups", force: :cascade do |t|
    t.string "regno"
    t.string "name"
    t.string "email_domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "web_domain"
    t.string "slug"
    t.index ["email_domain"], name: "index_charity_domain_lookups_on_email_domain"
    t.index ["regno"], name: "index_charity_domain_lookups_on_regno"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "location"
    t.string "audience"
    t.jsonb "subsector"
    t.integer "maturity"
    t.boolean "anchor_org"
    t.string "slug", null: false
    t.boolean "for_review", default: false
    t.jsonb "org_ids", default: []
    t.jsonb "potential_org_ids", default: []
    t.jsonb "alternate_names", default: []
    t.index ["slug"], name: "index_organisations_on_slug", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.bigint "organisation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organisation_id"], name: "index_people_on_organisation_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "potential_actions", force: :cascade do |t|
    t.string "name"
    t.string "format"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "actions", "organisations"
  add_foreign_key "actions", "people"
  add_foreign_key "actions", "potential_actions"
  add_foreign_key "affiliations", "organisations"
  add_foreign_key "affiliations", "users", column: "individual_id"
  add_foreign_key "people", "organisations"
end
