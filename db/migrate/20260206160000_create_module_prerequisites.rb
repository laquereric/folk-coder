class CreateModulePrerequisites < ActiveRecord::Migration[8.0]
  def change
    create_table :module_prerequisites do |t|
      t.references :curriculum_module, null: false, foreign_key: { to_table: :modules }
      t.references :prerequisite_module, null: false, foreign_key: { to_table: :modules }
      t.timestamps
    end

    add_index :module_prerequisites, [:curriculum_module_id, :prerequisite_module_id], unique: true, name: 'idx_module_prereqs_unique'
  end
end
