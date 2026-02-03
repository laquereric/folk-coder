class AddGeographyToHackathons < ActiveRecord::Migration[8.1]
  def change
    add_column :hackathons, :country, :string
    add_column :hackathons, :region, :string
  end
end
