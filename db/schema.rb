# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_01_15_212814) do
  create_table "announcements", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.boolean "published"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "frontpage", default: false
    t.boolean "contest_only", default: false
    t.string "title"
    t.string "notes"
  end

  create_table "contests", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.boolean "enabled"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
  end

  create_table "contests_problems", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "problem_id"
  end

  create_table "contests_users", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "user_id"
  end

  create_table "countries", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "descriptions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.boolean "markdowned"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "grader_configurations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key"
    t.string "value_type"
    t.string "value"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "description"
  end

  create_table "grader_processes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "host"
    t.integer "pid"
    t.string "mode"
    t.boolean "active"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "task_id"
    t.string "task_type"
    t.boolean "terminated"
    t.index ["host", "pid"], name: "index_grader_processes_on_host_and_pid"
  end

  create_table "groups", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "groups_problems", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "problem_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id", "problem_id"], name: "index_groups_problems_on_group_id_and_problem_id"
  end

  create_table "groups_users", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"
  end

  create_table "heart_beats", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.index ["updated_at"], name: "index_heart_beats_on_updated_at"
  end

  create_table "languages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 10
    t.string "pretty_name"
    t.string "ext", limit: 10
    t.string "common_ext"
  end

  create_table "logins", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "messages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "replying_message_id"
    t.text "body"
    t.boolean "replied"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "problems", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 30
    t.string "full_name"
    t.integer "full_score"
    t.date "date_added"
    t.boolean "available"
    t.string "url"
    t.integer "description_id"
    t.boolean "test_allowed"
    t.boolean "output_only"
    t.string "description_filename"
    t.boolean "view_testcase"
  end

  create_table "problems_tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "tag_id"
    t.index ["problem_id", "tag_id"], name: "index_problems_tags_on_problem_id_and_tag_id", unique: true
    t.index ["problem_id"], name: "index_problems_tags_on_problem_id"
    t.index ["tag_id"], name: "index_problems_tags_on_tag_id"
  end

  create_table "rights", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
  end

  create_table "rights_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "right_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_rights_roles_on_role_id"
  end

  create_table "roles", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "sessions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "session_id"
    t.text "data"
    t.datetime "updated_at", precision: nil
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sites", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "started"
    t.datetime "start_time", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "country_id"
    t.string "password"
  end

  create_table "submission_view_logs", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "submission_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "submissions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
    t.integer "language_id"
    t.text "source", size: :medium
    t.binary "binary"
    t.datetime "submitted_at", precision: nil
    t.datetime "compiled_at", precision: nil
    t.text "compiler_message"
    t.datetime "graded_at", precision: nil
    t.integer "points"
    t.text "grader_comment"
    t.integer "number"
    t.string "source_filename"
    t.float "max_runtime"
    t.integer "peak_memory"
    t.integer "effective_code_length"
    t.string "ip_address"
    t.index ["user_id", "problem_id", "number"], name: "index_submissions_on_user_id_and_problem_id_and_number", unique: true
    t.index ["user_id", "problem_id"], name: "index_submissions_on_user_id_and_problem_id"
  end

  create_table "tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "public"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "tasks", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "submission_id"
    t.datetime "created_at", precision: nil
    t.integer "status"
    t.datetime "updated_at", precision: nil
    t.index ["submission_id"], name: "index_tasks_on_submission_id"
  end

  create_table "test_pairs", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "problem_id"
    t.text "input", size: :medium
    t.text "solution", size: :medium
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "test_requests", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
    t.integer "submission_id"
    t.string "input_file_name"
    t.string "output_file_name"
    t.string "running_stat"
    t.integer "status"
    t.datetime "updated_at", precision: nil
    t.datetime "submitted_at", precision: nil
    t.datetime "compiled_at", precision: nil
    t.text "compiler_message"
    t.datetime "graded_at", precision: nil
    t.string "grader_comment"
    t.datetime "created_at", precision: nil
    t.float "running_time"
    t.string "exit_status"
    t.integer "memory_usage"
    t.index ["user_id", "problem_id"], name: "index_test_requests_on_user_id_and_problem_id"
  end

  create_table "testcases", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "num"
    t.integer "group"
    t.integer "score"
    t.text "input", size: :long
    t.text "sol", size: :long
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["problem_id"], name: "index_testcases_on_problem_id"
  end

  create_table "user_contest_stats", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.timestamp "started_at"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "forced_logout"
  end

  create_table "users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "login", limit: 50
    t.string "full_name"
    t.string "hashed_password"
    t.string "salt", limit: 5
    t.string "alias"
    t.string "email"
    t.integer "site_id"
    t.integer "country_id"
    t.boolean "activated", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "section"
    t.boolean "enabled", default: true
    t.string "remark"
    t.string "last_ip"
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "problems_tags", "problems"
  add_foreign_key "problems_tags", "tags"
end
