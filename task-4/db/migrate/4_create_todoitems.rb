class CreateTodoitems < ActiveRecord::Migration
  def change
    create_table :todoitems do |t|
      t.string :title
      t.string :description
      t.datetime :date_due
      t.references :todolist
    end
  end
end
