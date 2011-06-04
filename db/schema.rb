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

ActiveRecord::Schema.define(:version => 20110602202109) do

  create_table "acquaintances", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "other_user_id"
  end

  create_table "activations", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "active"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updates_count"
    t.datetime "activation_changed_at"
  end

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "administrated_organizations_users", :id => false, :force => true do |t|
    t.integer "organization_id"
    t.integer "user_id"
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

  create_table "file_uploads", :force => true do |t|
    t.integer  "update_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "type"
    t.integer  "groupable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "groupable_type"
  end

  create_table "groups_updates", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "update_id"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "managed_organizations_users", :id => false, :force => true do |t|
    t.integer "organization_id"
    t.integer "user_id"
  end

  create_table "notifications", :id => false, :force => true do |t|
    t.string  "key"
    t.string  "target_class"
    t.integer "target_id"
  end

  add_index "notifications", ["key"], :name => "index_notifications_on_key"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations_users", :id => false, :force => true do |t|
    t.integer "organization_id"
    t.integer "user_id"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tags_updates", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "update_id"
  end

  create_table "updates", :force => true do |t|
    t.string   "title"
    t.integer  "author_id"
    t.integer  "activation_id"
    t.text     "body"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "file_uploads_count"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name_prefix"
    t.string   "name_suffix"
    t.text     "phone_numbers"
    t.text     "email_addresses"
    t.datetime "deleted_at"
    t.string   "password_hash",      :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "primary_address_id"
    t.string   "avatar_file_name"
    t.datetime "avatar_updated_at"
  end

end
