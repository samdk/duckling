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

ActiveRecord::Schema.define(:version => 20120716193600) do

  create_table "acquaintances", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "other_user_id"
  end

  add_index "acquaintances", ["other_user_id"], :name => "index_acquaintances_on_other_user_id"
  add_index "acquaintances", ["user_id"], :name => "index_acquaintances_on_user_id"

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

  create_table "activations_organizations", :force => true do |t|
    t.integer "organization_id"
    t.integer "activation_id"
  end

  add_index "activations_organizations", ["activation_id"], :name => "index_activations_organizations_on_activation_id"
  add_index "activations_organizations", ["organization_id"], :name => "index_activations_organizations_on_organization_id"

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

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

  add_index "attachments", ["attachable_id"], :name => "index_attachments_on_attachable_id"
  add_index "attachments", ["attachable_type"], :name => "index_attachments_on_attachable_type"
  add_index "attachments", ["file_content_type"], :name => "index_attachments_on_file_content_type"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "author_id"
    t.integer  "update_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["update_id"], :name => "index_comments_on_update_id"

  create_table "emails", :force => true do |t|
    t.string   "email",           :limit => 256
    t.string   "state",           :limit => 16,  :default => "unverified"
    t.string   "secret_code",     :limit => 64
    t.integer  "user_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.datetime "emailed_at",                     :default => '0000-01-01 05:00:00'
    t.integer  "annoyance_level",                :default => 0
  end

  add_index "emails", ["email"], :name => "index_emails_on_email"
  add_index "emails", ["secret_code"], :name => "index_emails_on_secret_code"
  add_index "emails", ["user_id"], :name => "index_emails_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "email_id"
    t.integer  "inviter_id"
    t.integer  "invitable_id"
    t.string   "invitable_type"
    t.boolean  "emailed",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "invitations", ["email_id"], :name => "index_invitations_on_email_id"
  add_index "invitations", ["emailed"], :name => "index_invitations_on_emailed"
  add_index "invitations", ["invitable_id", "invitable_type"], :name => "index_invitations_on_invitable_id_and_invitable_type"
  add_index "invitations", ["inviter_id"], :name => "index_invitations_on_inviter_id"

  create_table "memberships", :force => true do |t|
    t.integer "container_id"
    t.string  "container_type"
    t.integer "user_id"
    t.integer "creating_user_id"
    t.string  "access_level",     :default => ""
  end

  add_index "memberships", ["container_id", "container_type"], :name => "index_memberships_on_container_id_and_container_type"
  add_index "memberships", ["creating_user_id"], :name => "index_memberships_on_creating_user_id"
  add_index "memberships", ["user_id", "container_type"], :name => "index_memberships_on_user_id_and_container_type"

  create_table "notifications", :force => true do |t|
    t.string   "event"
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "dismissed",   :default => false
    t.boolean  "emailed",     :default => false
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "notifications", ["target_type", "target_id"], :name => "index_notifications_on_target_type_and_target_id"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "organizations", :force => true do |t|
    t.string   "name",        :limit => 128
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "organizations_sections", :force => true do |t|
    t.integer "organization_id"
    t.integer "section_id"
  end

  add_index "organizations_sections", ["organization_id"], :name => "index_organizations_sections_on_organization_id"
  add_index "organizations_sections", ["section_id"], :name => "index_organizations_sections_on_section_id"

  create_table "sections", :force => true do |t|
    t.string   "name",          :limit => 50
    t.string   "description",   :limit => 1000
    t.integer  "activation_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "sections", ["activation_id"], :name => "index_sections_on_activation_id"
  add_index "sections", ["name"], :name => "index_sections_on_name"

  create_table "sections_updates", :force => true do |t|
    t.integer "update_id"
    t.integer "section_id"
  end

  add_index "sections_updates", ["section_id"], :name => "index_sections_updates_on_section_id"
  add_index "sections_updates", ["update_id"], :name => "index_sections_updates_on_update_id"

  create_table "tags", :force => true do |t|
    t.string "name", :limit => 32
  end

  create_table "tasks", :force => true do |t|
    t.integer "target_id"
    t.string  "target_type"
    t.string  "method"
    t.text    "args"
  end

  add_index "tasks", ["target_id"], :name => "index_tasks_on_target_id"
  add_index "tasks", ["target_type"], :name => "index_tasks_on_target_type"

  create_table "updates", :force => true do |t|
    t.string   "title",          :limit => 128
    t.integer  "author_id"
    t.integer  "activation_id"
    t.text     "body"
    t.integer  "comments_count"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "updates", ["activation_id"], :name => "index_updates_on_activation_id"
  add_index "updates", ["author_id"], :name => "index_updates_on_author_id"

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
    t.integer  "primary_email_id"
    t.string   "time_zone",                              :default => "UTC"
  end

  add_index "users", ["cookie_token"], :name => "index_users_on_cookie_token"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["primary_address_id"], :name => "index_users_on_primary_address_id"
  add_index "users", ["primary_email_id"], :name => "index_users_on_primary_email_id"

end
