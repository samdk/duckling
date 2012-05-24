class AddTasks < ActiveRecord::Migration
  def change
    create_table 'tasks' do |t|
      t.references :target, polymorphic: true
      t.string :method
      t.text :args
    end
  end
end
