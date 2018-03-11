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

ActiveRecord::Schema.define(version: 20180311183836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "person_id"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_addresses_on_person_id"
  end

  create_table "assignment_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "assignment_type_id"
    t.integer "employee"
    t.date "assigned_at"
    t.integer "assigned_by"
    t.bigint "company_unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_type_id"], name: "index_assignments_on_assignment_type_id"
    t.index ["company_unit_id"], name: "index_assignments_on_company_unit_id"
  end

  create_table "benefit_types", force: :cascade do |t|
    t.string "name"
    t.integer "eligibility_interval"
    t.string "eligibility_interval_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "benefits", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "benefit_type_id"
    t.date "eligible_at"
    t.date "notified_at"
    t.integer "updated_by"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_type_id"], name: "index_benefits_on_benefit_type_id"
    t.index ["employee_id"], name: "index_benefits_on_employee_id"
  end

  create_table "certification_types", force: :cascade do |t|
    t.string "name"
    t.integer "effective_interval"
    t.string "effective_interval_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certifications", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "certification_type_id"
    t.string "certification_number"
    t.date "renewed_at"
    t.date "expires_at"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certification_type_id"], name: "index_certifications_on_certification_type_id"
    t.index ["employee_id"], name: "index_certifications_on_employee_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_units", force: :cascade do |t|
    t.string "name"
    t.integer "manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_company_units_on_company_id"
  end

  create_table "contact_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "contact_type_id"
    t.string "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_id"
    t.index ["contact_type_id"], name: "index_contacts_on_contact_type_id"
    t.index ["person_id"], name: "index_contacts_on_person_id"
  end

  create_table "demographics", force: :cascade do |t|
    t.bigint "race_id"
    t.bigint "ethnicity_id"
    t.bigint "contact_id"
    t.bigint "emergency_contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_id"
    t.index ["contact_id"], name: "index_demographics_on_contact_id"
    t.index ["emergency_contact_id"], name: "index_demographics_on_emergency_contact_id"
    t.index ["ethnicity_id"], name: "index_demographics_on_ethnicity_id"
    t.index ["person_id"], name: "index_demographics_on_person_id"
    t.index ["race_id"], name: "index_demographics_on_race_id"
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.bigint "relationship_type_id"
    t.string "first_name"
    t.string "last_name"
    t.bigint "contact_type_id"
    t.string "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_type_id"], name: "index_emergency_contacts_on_contact_type_id"
    t.index ["relationship_type_id"], name: "index_emergency_contacts_on_relationship_type_id"
  end

  create_table "employees", force: :cascade do |t|
    t.boolean "active", default: true
    t.date "temp_hire_at"
    t.date "full_time_hire_at"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_employees_on_person_id"
  end

  create_table "ethnicities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "prefix"
    t.string "suffix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_birth"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationship_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remuneration_types", force: :cascade do |t|
    t.string "name"
    t.integer "pay_period_hours"
    t.integer "annual_pay_periods"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remunerations", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "remuneration_type_id"
    t.integer "updated_by"
    t.decimal "pay_period_salary"
    t.decimal "annual_salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_remunerations_on_employee_id"
    t.index ["remuneration_type_id"], name: "index_remunerations_on_remuneration_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "people"
  add_foreign_key "assignments", "assignment_types"
  add_foreign_key "assignments", "company_units"
  add_foreign_key "assignments", "employees", column: "assigned_by"
  add_foreign_key "benefits", "benefit_types"
  add_foreign_key "benefits", "employees"
  add_foreign_key "benefits", "employees", column: "updated_by"
  add_foreign_key "certifications", "certification_types"
  add_foreign_key "certifications", "employees"
  add_foreign_key "certifications", "employees", column: "updated_by"
  add_foreign_key "company_units", "companies"
  add_foreign_key "company_units", "employees", column: "manager"
  add_foreign_key "contacts", "contact_types"
  add_foreign_key "contacts", "people"
  add_foreign_key "demographics", "contacts"
  add_foreign_key "demographics", "emergency_contacts"
  add_foreign_key "demographics", "ethnicities"
  add_foreign_key "demographics", "people"
  add_foreign_key "demographics", "races"
  add_foreign_key "emergency_contacts", "contact_types"
  add_foreign_key "emergency_contacts", "relationship_types"
  add_foreign_key "employees", "people"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "people", "users"
  add_foreign_key "remunerations", "employees"
  add_foreign_key "remunerations", "employees", column: "updated_by"
  add_foreign_key "remunerations", "remuneration_types"
end
