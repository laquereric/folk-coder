class CurriculumModule < ApplicationRecord
  self.table_name = "modules"

  has_many :lessons, -> { order(:position) }, dependent: :destroy

  # Single prerequisite (legacy, kept for backwards compatibility)
  belongs_to :prerequisite_module, class_name: "CurriculumModule", optional: true
  has_many :dependent_modules, class_name: "CurriculumModule", foreign_key: :prerequisite_module_id

  # Multiple prerequisites
  has_many :module_prerequisites, dependent: :destroy
  has_many :prerequisite_modules, through: :module_prerequisites, source: :prerequisite_module

  default_scope { order(:position) }

  def completed_by?(user)
    return false unless user
    lessons.all? { |lesson| lesson.completed_by?(user) }
  end

  def unlocked_for?(user)
    # Check single prerequisite (legacy)
    if prerequisite_module.present?
      return false unless prerequisite_module.completed_by?(user)
    end

    # Check multiple prerequisites
    prerequisite_modules.each do |prereq|
      return false unless prereq.completed_by?(user)
    end

    true
  end

  def locked_for?(user)
    !unlocked_for?(user)
  end

  def all_prerequisites
    prereqs = prerequisite_modules.to_a
    prereqs << prerequisite_module if prerequisite_module.present?
    prereqs.uniq
  end
end
