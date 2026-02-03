class CreateModules < ActiveRecord::Migration[8.1]
  def change
    create_table :modules do |t|
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
