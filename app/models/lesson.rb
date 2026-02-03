class Lesson < ApplicationRecord
  belongs_to :curriculum_module, foreign_key: :curriculum_module_id
  has_many :lesson_completions, dependent: :destroy

  default_scope { order(:position) }

  def completed_by?(user)
    return false unless user
    lesson_completions.exists?(user: user)
  end

  def next_lesson
    Lesson.unscoped.where(curriculum_module_id: curriculum_module_id)
          .where("position > ?", position)
          .order(:position).first
  end
end
