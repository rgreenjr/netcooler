# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 36) do

  create_table "avatars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "db_file_id"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.integer  "commentable_id",                           :null => false
    t.string   "commentable_type", :default => "",         :null => false
    t.text     "body"
    t.text     "body_html"
    t.string   "status",           :default => "Approved", :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "companies", :force => true do |t|
    t.string   "name",          :default => "",         :null => false
    t.text     "description"
    t.integer  "industry_id",                           :null => false
    t.string   "url",           :default => "",         :null => false
    t.string   "domain",        :default => "",         :null => false
    t.string   "ticker_symbol"
    t.integer  "post_count",    :default => 0,          :null => false
    t.string   "status",        :default => "Approved", :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "companies", ["name"], :name => "index_companies_on_name"
  add_index "companies", ["industry_id"], :name => "index_companies_on_industry_id"
  add_index "companies", ["status"], :name => "index_companies_on_status"
  add_index "companies", ["domain"], :name => "index_companies_on_domain"

  create_table "countries", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.string   "code",       :limit => 2,   :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "industries", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "industries", ["name"], :name => "index_industries_on_name"

  create_table "offices", :force => true do |t|
    t.integer  "company_id",                 :null => false
    t.string   "street1"
    t.string   "street2"
    t.string   "city",       :default => "", :null => false
    t.integer  "state_id"
    t.string   "zip"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "country_id",                 :null => false
  end

  add_index "offices", ["company_id"], :name => "index_offices_on_company_id"
  add_index "offices", ["state_id"], :name => "index_offices_on_state_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "company_id",                         :null => false
    t.string   "category",   :default => "",         :null => false
    t.string   "title"
    t.text     "body"
    t.text     "body_html"
    t.string   "url"
    t.integer  "hits",       :default => 0,          :null => false
    t.string   "status",     :default => "Approved", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"
  add_index "posts", ["company_id"], :name => "index_posts_on_company_id"
  add_index "posts", ["company_id", "status", "created_at"], :name => "index_posts_on_company_id_and_status_and_created_at"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "value",                         :null => false
    t.integer  "rateable_id",                   :null => false
    t.string   "rateable_type", :default => "", :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"
  add_index "ratings", ["rateable_id"], :name => "index_ratings_on_rateable_id"
  add_index "ratings", ["rateable_type"], :name => "index_ratings_on_rateable_type"
  add_index "ratings", ["rateable_id", "rateable_type"], :name => "index_ratings_on_rateable_id_and_rateable_type"
  add_index "ratings", ["user_id", "rateable_type"], :name => "index_ratings_on_user_id_and_rateable_type"
  add_index "ratings", ["user_id", "rateable_id", "rateable_type"], :name => "index_ratings_on_user_id_and_rateable_id_and_rateable_type"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name",         :default => "", :null => false
    t.string   "abbreviation", :default => "", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "country_id",                   :null => false
  end

  add_index "states", ["name"], :name => "index_states_on_name"
  add_index "states", ["abbreviation"], :name => "index_states_on_abbreviation"
  add_index "states", ["country_id"], :name => "fk_states_country_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",                        :null => false
    t.integer  "taggable_id",                   :null => false
    t.string   "taggable_type", :default => "", :null => false
    t.integer  "user_id",                       :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "taggings", ["user_id"], :name => "index_taggings_on_user_id"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "username",      :limit => 100, :default => "",           :null => false
    t.string   "email",         :limit => 100, :default => "",           :null => false
    t.boolean  "email_optin",                  :default => false,        :null => false
    t.string   "first_name",    :limit => 100, :default => "",           :null => false
    t.string   "last_name",     :limit => 100, :default => "",           :null => false
    t.string   "password_hash", :limit => 40,  :default => "",           :null => false
    t.boolean  "admin",                        :default => false,        :null => false
    t.string   "status",                       :default => "Registered", :null => false
    t.datetime "last_login_at"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username"
  add_index "users", ["password_hash"], :name => "index_users_on_password_hash"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "username"], :name => "index_users_on_id_and_username"
  add_index "users", ["id", "email"], :name => "index_users_on_id_and_email"
  add_index "users", ["username", "password_hash"], :name => "index_users_on_username_and_password_hash"

end
