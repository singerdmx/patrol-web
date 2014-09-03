# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140903053750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "areas", force: true do |t|
    t.string   "name"
    t.integer  "subfactory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["subfactory_id"], name: "index_areas_on_subfactory_id", using: :btree

  create_table "assets", force: true do |t|
    t.string   "number"
    t.string   "parent"
    t.string   "serialnum"
    t.string   "tag"
    t.string   "location"
    t.string   "name"
    t.text     "description"
    t.string   "vendor"
    t.string   "failure_code"
    t.string   "manufacture"
    t.integer  "purchase_pri"
    t.float    "replace_cost"
    t.datetime "install_date"
    t.datetime "warranty_expire"
    t.float    "total_cost"
    t.float    "ytd_cost"
    t.float    "budget_cost"
    t.integer  "calnum"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "barcode"
  end

  add_index "assets", ["barcode"], name: "index_assets_on_barcode", using: :btree
  add_index "assets", ["number"], name: "index_assets_on_number", using: :btree

  create_table "check_points", force: true do |t|
    t.text     "description"
    t.string   "name"
    t.integer  "category"
    t.string   "choice"
    t.string   "state"
    t.string   "barcode"
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frequency",     default: 24
    t.string   "default_value"
  end

  create_table "check_results", force: true do |t|
    t.string   "result"
    t.integer  "status"
    t.string   "memo"
    t.datetime "check_time"
    t.integer  "check_point_id"
    t.integer  "check_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_routes", force: true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "area_id"
  end

  add_index "check_routes", ["area_id"], name: "index_check_routes_on_area_id", using: :btree

  create_table "check_sessions", force: true do |t|
    t.string   "user"
    t.string   "session"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "check_route_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "check_sessions", ["check_route_id"], name: "index_check_sessions_on_check_route_id", using: :btree

  create_table "factories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_builders", force: true do |t|
    t.integer  "check_route_id"
    t.integer  "check_point_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subfactories", force: true do |t|
    t.string   "name"
    t.integer  "factory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subfactories", ["factory_id"], name: "index_subfactories_on_factory_id", using: :btree

  create_table "user_builders", force: true do |t|
    t.integer  "user_id"
    t.integer  "check_route_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_preferences", force: true do |t|
    t.integer  "user_id"
    t.integer  "check_point_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
