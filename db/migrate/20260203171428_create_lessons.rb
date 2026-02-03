class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.integer :curriculum_module_id
      t.string :title
      t.text :description
      t.text :content
      t.integer :position

      t.timestamps
    end
    add_index :lessons, :curriculum_module_id
  end
end
