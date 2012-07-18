class RemoveTasks < ActiveRecord::Migration
  def up
    drop_table :tasks
  end

  def down
    create_table 'tasks' do |t|
      t.references :target, polymorphic: true
      t.string :method
      t.text :args
    end
  end
end
