class Hackathon < ApplicationRecord
  scope :upcoming, -> { where("start_date >= ?", Date.today).order(:start_date) }
  scope :by_theme, ->(theme) { where(theme: theme) if theme.present? }
  scope :by_location_type, ->(type) { where(location_type: type) if type.present? }
  scope :search, ->(query) { where("name LIKE ? OR description LIKE ? OR theme LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%") if query.present? }
end
