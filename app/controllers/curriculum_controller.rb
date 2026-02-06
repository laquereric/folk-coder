class CurriculumController < ApplicationController
  def index
    @modules = CurriculumModule.includes(:lessons, :prerequisite_module)
    @total_lessons = Lesson.count
    @completed_count = Current.user&.completed_lessons&.count || 0
  end
end
