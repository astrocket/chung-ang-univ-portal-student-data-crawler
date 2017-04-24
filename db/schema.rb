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

ActiveRecord::Schema.define(version: 20170424131157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name",               default: "n/a"
    t.string   "number",             default: "n/a"
    t.string   "location",           default: "n/a"
    t.string   "major",              default: "n/a"
    t.string   "lecture_number",     default: "n/a"
    t.string   "lecture_seperation", default: "n/a"
    t.string   "study_date",         default: "n/a"
    t.string   "year",               default: "n/a"
    t.string   "semester",           default: "n/a"
    t.string   "point",              default: "n/a"
    t.string   "campus",             default: "1"
    t.string   "department",         default: "n/a"
    t.string   "professor_name",     default: "n/a"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "courses_hakboos", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "hakboo_id", null: false
    t.index ["hakboo_id", "course_id"], name: "index_courses_hakboos_on_hakboo_id_and_course_id", using: :btree
  end

  create_table "courses_professors", id: false, force: :cascade do |t|
    t.integer "course_id",    null: false
    t.integer "professor_id", null: false
    t.index ["professor_id", "course_id"], name: "index_courses_professors_on_professor_id_and_course_id", using: :btree
  end

  create_table "hakboos", force: :cascade do |t|
    t.string   "name",       default: "n/a"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "hakboos_professors", id: false, force: :cascade do |t|
    t.integer "hakboo_id",    null: false
    t.integer "professor_id", null: false
  end

  create_table "hakboos_users", id: false, force: :cascade do |t|
    t.integer "hakboo_id", null: false
    t.integer "user_id",   null: false
    t.index ["user_id", "hakboo_id"], name: "index_hakboos_users_on_user_id_and_hakboo_id", using: :btree
  end

  create_table "information", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "mistakes", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: :cascade do |t|
    t.string   "number",     default: "n/a"
    t.string   "name",       default: "n/a"
    t.string   "email",      default: "n/a"
    t.string   "tel",        default: "n/a"
    t.string   "phone",      default: "n/a"
    t.string   "group",      default: "n/a"
    t.string   "college",    default: "n/a"
    t.string   "subject",    default: "n/a"
    t.string   "career",     default: "n/a"
    t.string   "site",       default: "n/a"
    t.string   "image",      default: "n/a"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "sugangs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_sugangs_on_course_id", using: :btree
    t.index ["user_id"], name: "index_sugangs_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "student"
    t.string   "name"
    t.boolean  "status",                 default: false
    t.string   "gpa",                    default: "n/a"
    t.string   "birth",                  default: "n/a"
    t.string   "english_name",           default: "n/a"
    t.string   "chinese_name",           default: "n/a"
    t.string   "gender",                 default: "n/a"
    t.string   "department_name",        default: "n/a"
    t.string   "major_name",             default: "n/a"
    t.string   "recent_grade",           default: "n/a"
    t.string   "recent_year",            default: "n/a"
    t.string   "recent_semester",        default: "n/a"
    t.string   "campus",                 default: "n/a"
    t.string   "college_name",           default: "n/a"
    t.string   "college_code",           default: "n/a"
    t.string   "department_code",        default: "n/a"
    t.string   "major_code",             default: "n/a"
    t.float    "final_gpa",              default: 0.0
    t.string   "admission_type",         default: "n/a"
    t.string   "tel",                    default: "n/a"
    t.string   "phone",                  default: "n/a"
    t.string   "military",               default: "n/a"
    t.string   "mail",                   default: "n/a"
    t.string   "address",                default: "n/a"
    t.string   "preschool_type",         default: "n/a"
    t.string   "preschool_name",         default: "n/a"
    t.string   "parent_name",            default: "n/a"
    t.string   "parent_type",            default: "n/a"
    t.string   "parent_tel",             default: "n/a"
    t.string   "parent_phone",           default: "n/a"
    t.string   "parent_address",         default: "n/a"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "messages", "users"
  add_foreign_key "sugangs", "courses"
  add_foreign_key "sugangs", "users"
end
