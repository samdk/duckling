class Activations < ActiveRecord::Migration
  def change
    create_table 'activations', force: true do |t|
      t.string   'title',                    limit: 128
      t.text     'description'
      t.boolean  'active'
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'updates_count'
      t.datetime 'active_or_inactive_since'
    end
  end
end
