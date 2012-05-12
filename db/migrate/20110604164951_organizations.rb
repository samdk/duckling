class Organizations < ActiveRecord::Migration
  def change
    create_table 'organizations' do |t|
      t.string   'name',       limit: 128
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end
end
