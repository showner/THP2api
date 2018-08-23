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

ActiveRecord::Schema.define(version: 2018_08_22_073958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "course_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 50
    t.datetime "starting_date", null: false
    t.datetime "ending_date"
    t.integer "student_max", null: false
    t.integer "student_min", default: 2, null: false
    t.uuid "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "creator_id"
    t.index ["course_id"], name: "index_course_sessions_on_course_id"
    t.index ["creator_id"], name: "index_course_sessions_on_creator_id"
  end

  create_table "courses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", limit: 50, null: false
    t.text "description", null: false
    t.integer "lessons_count", default: 0
    t.uuid "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sessions_count", default: 0
    t.index ["creator_id"], name: "index_courses_on_creator_id"
  end

  create_table "lessons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", limit: 50, null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "creator_id"
    t.uuid "course_id"
    t.index ["course_id"], name: "index_lessons_on_course_id"
    t.index ["creator_id"], name: "index_lessons_on_creator_id"
  end

  create_table "organization_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_organization_memberships_on_member_id"
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "website"
    t.integer "created_sessions_count", default: 0
    t.uuid "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "members_count", default: 0
    t.index ["creator_id"], name: "index_organizations_on_creator_id"
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_lessons_count", default: 0
    t.integer "created_courses_count", default: 0
    t.integer "created_organizations_count", default: 0
    t.integer "organizations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "course_sessions", "courses"
  add_foreign_key "course_sessions", "organizations", column: "creator_id"
  add_foreign_key "courses", "users", column: "creator_id"
  add_foreign_key "lessons", "courses"
  add_foreign_key "lessons", "users", column: "creator_id"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_memberships", "users", column: "member_id"
  add_foreign_key "organizations", "users", column: "creator_id"
end
