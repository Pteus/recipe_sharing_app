class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.text :instructions
      t.integer :prep_time
      t.integer :cook_time
      t.string :difficulty_level

      t.timestamps
    end
  end
end
