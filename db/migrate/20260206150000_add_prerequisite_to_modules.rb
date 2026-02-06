class AddPrerequisiteToModules < ActiveRecord::Migration[8.0]
  def change
    add_column :modules, :prerequisite_module_id, :integer
    add_index :modules, :prerequisite_module_id
    add_foreign_key :modules, :modules, column: :prerequisite_module_id
  end
end
