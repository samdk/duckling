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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120511193050) do

  create_table "acquaintances", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "other_user_id"
  end

  create_table "activations", :force => true do |t|
    t.string   "title",                    :limit => 128
    t.text     "description"
    t.boolean  "active"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updates_count"
    t.datetime "active_or_inactive_since"
  end

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "update_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deployments", :id => false, :force => true do |t|
    t.integer "activation_id"
    t.integer "deployed_id"
    t.boolean "active",        :default => true
    t.string  "deployed_type"
  end

  add_index "deployments", ["activation_id"], :name => "index_deployments_on_activation_id"
  add_index "deployments", ["deployed_id"], :name => "index_deployments_on_deployed_id"

  create_table "emails", :force => true do |t|
    t.string   "email",      :limit => 256
    t.string   "state",      :limit => 16,  :default => "unverified"
    t.integer  "user_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "emails", ["email", "state"], :name => "index_emails_on_email_and_state"
  add_index "emails", ["email"], :name => "index_emails_on_email"

  create_table "memberships", :id => false, :force => true do |t|
    t.integer "organization_id"
    t.integer "user_id"
    t.string  "access_level",    :default => ""
  end

  add_index "memberships", ["organization_id"], :name => "index_memberships_on_organization_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "notifications", :id => false, :force => true do |t|
    t.string  "key"
    t.string  "target_class"
    t.integer "target_id"
  end

  add_index "notifications", ["key"], :name => "index_notifications_on_key"

  create_table "organizations", :force => true do |t|
    t.string   "name",        :limit => 128
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description", :limit => 2500
  end

  create_table "sections", :force => true do |t|
    t.string   "name",           :limit => 50
    t.string   "description",    :limit => 1000
    t.integer  "groupable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "groupable_type"
  end

  create_table "sections_updates", :id => false, :force => true do |t|
    t.integer "section_id"
    t.integer "update_id"
  end

  create_table "sections_users", :id => false, :force => true do |t|
    t.integer "section_id"
    t.integer "user_id"
  end

  create_table "tags", :force => true do |t|
    t.string "name", :limit => 32
  end

  create_table "tags_updates", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "update_id"
  end

  create_table "updates", :force => true do |t|
    t.string   "title",          :limit => 128
    t.integer  "author_id"
    t.integer  "activation_id"
    t.text     "body"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",              :limit => 50
    t.string   "last_name",               :limit => 50
    t.string   "name_prefix",             :limit => 50
    t.string   "name_suffix",             :limit => 50
    t.string   "avatar_file_name",        :limit => 100
    t.string   "reset_token",             :limit => 64
    t.string   "state",                   :limit => 8,   :default => "active"
    t.string   "password_hash",           :limit => 100
    t.string   "cookie_token",            :limit => 128
    t.string   "api_token",               :limit => 64
    t.text     "phone_numbers"
    t.datetime "cookie_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.datetime "avatar_updated_at"
    t.integer  "primary_address_id"
    t.integer  "primary_organization_id"
    t.integer  "primary_email_id"
  end

  add_index "users", ["cookie_token"], :name => "index_users_on_cookie_token"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"

end
