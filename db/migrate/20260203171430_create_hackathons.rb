class CreateHackathons < ActiveRecord::Migration[8.1]
  def change
    create_table :hackathons do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :location
      t.string :location_type
      t.string :theme
      t.string :prize_pool
      t.string :registration_link
      t.string :source
      t.text :description

      t.timestamps
    end
  end
end
