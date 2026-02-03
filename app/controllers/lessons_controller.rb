class LessonsController < ApplicationController
  before_action :set_lesson

  def show
  end

  def complete
    Current.user.lesson_completions.find_or_create_by!(lesson: @lesson)
    redirect_to @lesson.next_lesson || curriculum_path, notice: "Lesson completed!"
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end
end
