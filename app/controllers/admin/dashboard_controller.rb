class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @total_admins = User.where(role: "admin").count
    @total_members = User.where(role: "member").count
    @recent_users = User.order(created_at: :desc).limit(10)
    @total_lessons = Lesson.count
    @total_completions = LessonCompletion.count
  end
end
