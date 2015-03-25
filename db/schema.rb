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

ActiveRecord::Schema.define(version: 20150325045729) do

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
    t.boolean  "tombstone",     default: false
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
    t.integer  "manual_id"
    t.boolean  "tombstone",       default: false
  end

  add_index "assets", ["barcode"], name: "index_assets_on_barcode", using: :btree
  add_index "assets", ["manual_id"], name: "index_assets_on_manual_id", using: :btree
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
    t.integer  "frequency",           default: 24
    t.string   "default_value"
    t.string   "measure_unit"
    t.string   "point_code"
    t.integer  "default_assigned_id"
    t.boolean  "tombstone",           default: false
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
    t.integer  "area_id",          null: false
    t.integer  "result_image_id"
    t.integer  "result_audio_id"
  end

  add_index "check_results", ["area_id"], name: "index_check_results_on_area_id", using: :btree
  add_index "check_results", ["result_audio_id"], name: "index_check_results_on_result_audio_id", using: :btree
  add_index "check_results", ["result_image_id"], name: "index_check_results_on_result_image_id", using: :btree

  create_table "check_routes", force: true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "area_id"
    t.string   "contacts"
    t.boolean  "tombstone",   default: false
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
    t.string   "submitter"
  end

  add_index "check_sessions", ["check_route_id"], name: "index_check_sessions_on_check_route_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "factories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tombstone",  default: false
  end

  create_table "manuals", force: true do |t|
    t.text     "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tombstone",  default: false
  end

  create_table "parts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "barcode"
    t.integer  "asset_id"
    t.integer  "default_assigned_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tombstone",           default: false
  end

  add_index "parts", ["asset_id"], name: "index_parts_on_asset_id", using: :btree

  create_table "repair_reports", force: true do |t|
    t.string   "kind",                    null: false
    t.string   "code"
    t.text     "description"
    t.text     "content"
    t.boolean  "stopped",                 null: false
    t.boolean  "production_line_stopped", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_id",                null: false
    t.integer  "check_point_id"
    t.integer  "created_by_id",           null: false
    t.integer  "assigned_to_id"
    t.integer  "priority"
    t.integer  "report_type",             null: false
    t.integer  "status",                  null: false
    t.integer  "check_result_id"
    t.date     "plan_date"
    t.integer  "area_id",                 null: false
    t.integer  "result_image_id"
    t.integer  "result_audio_id"
    t.integer  "part_id"
  end

  add_index "repair_reports", ["area_id"], name: "index_repair_reports_on_area_id", using: :btree
  add_index "repair_reports", ["asset_id"], name: "index_repair_reports_on_asset_id", using: :btree
  add_index "repair_reports", ["check_point_id"], name: "index_repair_reports_on_check_point_id", using: :btree
  add_index "repair_reports", ["check_result_id"], name: "index_repair_reports_on_check_result_id", using: :btree
  add_index "repair_reports", ["part_id"], name: "index_repair_reports_on_part_id", using: :btree
  add_index "repair_reports", ["result_audio_id"], name: "index_repair_reports_on_result_audio_id", using: :btree
  add_index "repair_reports", ["result_image_id"], name: "index_repair_reports_on_result_image_id", using: :btree

  create_table "result_audios", force: true do |t|
    t.string   "name"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_images", force: true do |t|
    t.string   "name"
    t.text     "url"
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
    t.boolean  "tombstone",  default: false
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
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
    t.string   "name"
    t.boolean  "tombstone",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
