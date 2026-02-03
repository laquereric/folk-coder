require "test_helper"

class LessonTest < ActiveSupport::TestCase
  test "belongs to curriculum module" do
    assert_equal "SwarmPod Fundamentals", lessons(:multi_repo).curriculum_module.title
  end

  test "completed_by? returns true for completed lesson" do
    assert lessons(:multi_repo).completed_by?(users(:alice))
  end

  test "completed_by? returns false for incomplete lesson" do
    assert_not lessons(:secrets).completed_by?(users(:alice))
  end

  test "completed_by? returns false for nil user" do
    assert_not lessons(:multi_repo).completed_by?(nil)
  end

  test "next_lesson returns next by position" do
    assert_equal lessons(:secrets), lessons(:multi_repo).next_lesson
  end

  test "next_lesson returns nil for last lesson" do
    assert_nil lessons(:docker).next_lesson
  end
end
