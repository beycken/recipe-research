class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :rate
      t.integer :people_quantity
      t.integer :nb_comments
      t.string :difficulty
      t.string :author_tip
      t.string :budget
      t.string :prep_time
      t.string :cook_time
      t.string :total_time

      t.timestamps
    end
  end
end
