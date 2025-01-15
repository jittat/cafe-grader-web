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

ActiveRecord::Schema[6.1].define(version: 2018_06_12_102327) do

  create_table "announcements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.boolean "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "frontpage", default: false
    t.boolean "contest_only", default: false
    t.string "title"
    t.string "notes"
  end

  create_table "contests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.boolean "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
  end

  create_table "contests_problems", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "problem_id"
  end

  create_table "contests_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "user_id"
  end

  create_table "countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "body"
    t.boolean "markdowned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grader_configurations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "key"
    t.string "value_type"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
  end

  create_table "grader_processes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "host"
    t.integer "pid"
    t.string "mode"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "task_id"
    t.string "task_type"
    t.boolean "terminated"
    t.index ["host", "pid"], name: "index_grader_processes_on_host_and_pid"
  end

  create_table "groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "groups_problems", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "problem_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id", "problem_id"], name: "index_groups_problems_on_group_id_and_problem_id"
  end

  create_table "groups_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"
  end

  create_table "heart_beats", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status"
    t.index ["updated_at"], name: "index_heart_beats_on_updated_at"
  end

  create_table "languages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", limit: 10
    t.string "pretty_name"
    t.string "ext", limit: 10
    t.string "common_ext"
  end

  create_table "logins", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "replying_message_id"
    t.text "body"
    t.boolean "replied"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
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

  create_table "problems_tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "tag_id"
    t.index ["problem_id", "tag_id"], name: "index_problems_tags_on_problem_id_and_tag_id", unique: true
    t.index ["problem_id"], name: "index_problems_tags_on_problem_id"
    t.index ["tag_id"], name: "index_problems_tags_on_tag_id"
  end

  create_table "rights", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
  end

  create_table "rights_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "right_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_rights_roles_on_role_id"
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "session_id"
    t.text "data"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sites", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.boolean "started"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "country_id"
    t.string "password"
  end

  create_table "submission_view_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
    t.integer "language_id"
    t.text "source", limit: 16777215
    t.binary "binary"
    t.datetime "submitted_at"
    t.datetime "compiled_at"
    t.text "compiler_message"
    t.datetime "graded_at"
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

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "submission_id"
    t.datetime "created_at"
    t.integer "status"
    t.datetime "updated_at"
    t.index ["submission_id"], name: "index_tasks_on_submission_id"
  end

  create_table "test_pairs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "problem_id"
    t.text "input", limit: 16777215
    t.text "solution", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_requests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
    t.integer "submission_id"
    t.string "input_file_name"
    t.string "output_file_name"
    t.string "running_stat"
    t.integer "status"
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.datetime "compiled_at"
    t.text "compiler_message"
    t.datetime "graded_at"
    t.string "grader_comment"
    t.datetime "created_at"
    t.float "running_time"
    t.string "exit_status"
    t.integer "memory_usage"
    t.index ["user_id", "problem_id"], name: "index_test_requests_on_user_id_and_problem_id"
  end

  create_table "testcases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "num"
    t.integer "group"
    t.integer "score"
    t.text "input", limit: 4294967295
    t.text "sol", limit: 4294967295
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["problem_id"], name: "index_testcases_on_problem_id"
  end

  create_table "user_contest_stats", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "forced_logout"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "login", limit: 50
    t.string "full_name"
    t.string "hashed_password"
    t.string "salt", limit: 5
    t.string "alias"
    t.string "email"
    t.integer "site_id"
    t.integer "country_id"
    t.boolean "activated", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "section"
    t.boolean "enabled", default: true
    t.string "remark"
    t.string "last_ip"
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "problems_tags", "problems"
  add_foreign_key "problems_tags", "tags"
end
