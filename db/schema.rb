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

ActiveRecord::Schema.define(version: 20180301193350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  create_table "contact_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "relationship_type_id"
    t.string "first_name"
    t.string "last_name"
    t.bigint "contact_type_id"
    t.string "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_type_id"], name: "index_emergency_contacts_on_contact_type_id"
    t.index ["employee_id"], name: "index_emergency_contacts_on_employee_id"
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

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "prefix"
    t.string "suffix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "assignments", "assignment_types"
  add_foreign_key "assignments", "company_units"
  add_foreign_key "assignments", "employees", column: "assigned_by"
  add_foreign_key "benefits", "benefit_types"
  add_foreign_key "benefits", "employees"
  add_foreign_key "benefits", "employees", column: "updated_by"
  add_foreign_key "certifications", "certification_types"
  add_foreign_key "certifications", "employees"
  add_foreign_key "certifications", "employees", column: "updated_by"
  add_foreign_key "company_units", "employees", column: "manager"
  add_foreign_key "emergency_contacts", "contact_types"
  add_foreign_key "emergency_contacts", "employees"
  add_foreign_key "emergency_contacts", "relationship_types"
  add_foreign_key "employees", "people"
  add_foreign_key "remunerations", "employees"
  add_foreign_key "remunerations", "employees", column: "updated_by"
  add_foreign_key "remunerations", "remuneration_types"
end
