class JourneyController < ApplicationController
  before_action :require_authentication

  def show
    @user = Current.user
    @modules = CurriculumModule.includes(:lessons).order(:position)
    @total_lessons = Lesson.count
    @completed_lessons = @user.completed_lessons.to_a
    @completed_count = @completed_lessons.size
    @progress_percentage = @total_lessons > 0 ? (@completed_count.to_f / @total_lessons * 100).round : 0

    # Calculate streak (consecutive days with completions)
    @streak = calculate_streak

    # Next lesson to complete
    @next_lesson = find_next_lesson

    # Recent activity
    @recent_completions = @user.lesson_completions.includes(:lesson).order(created_at: :desc).limit(5)

    # Milestones
    @milestones = calculate_milestones
  end

  private

  def calculate_streak
    completions = Current.user.lesson_completions.order(created_at: :desc).pluck(:created_at)
    return 0 if completions.empty?

    streak = 0
    current_date = Date.current

    completions.map(&:to_date).uniq.each do |date|
      if date == current_date || date == current_date - streak.days
        streak += 1
        current_date = date
      else
        break
      end
    end

    streak
  end

  def find_next_lesson
    completed_ids = @completed_lessons.map(&:id)
    Lesson.where.not(id: completed_ids).order(:position).first
  end

  def calculate_milestones
    milestones = []

    # First lesson milestone
    milestones << {
      name: "First Steps",
      description: "Complete your first lesson",
      achieved: @completed_count >= 1,
      icon: "1"
    }

    # Halfway milestone
    halfway = (@total_lessons / 2.0).ceil
    milestones << {
      name: "Halfway There",
      description: "Complete #{halfway} lessons",
      achieved: @completed_count >= halfway,
      icon: "50%"
    }

    # Complete a module
    modules_completed = @modules.count { |m| m.lessons.all? { |l| l.completed_by?(@user) } }
    milestones << {
      name: "Module Master",
      description: "Complete an entire module",
      achieved: modules_completed >= 1,
      icon: "M"
    }

    # All lessons
    milestones << {
      name: "SwarmPod Graduate",
      description: "Complete all lessons",
      achieved: @completed_count >= @total_lessons && @total_lessons > 0,
      icon: "G"
    }

    milestones
  end
end
