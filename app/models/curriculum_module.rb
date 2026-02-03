class CurriculumModule < ApplicationRecord
  self.table_name = "modules"

  has_many :lessons, -> { order(:position) }, dependent: :destroy

  default_scope { order(:position) }
end
