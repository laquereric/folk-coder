require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(name: "Test", email_address: "new@example.com", password: "password123", password_confirmation: "password123")
    assert user.valid?
  end

  test "requires password" do
    user = User.new(name: "Test", email_address: "new@example.com")
    assert_not user.valid?
  end

  test "requires unique email at database level" do
    user = User.new(name: "Test", email_address: users(:alice).email_address, password: "password123", password_confirmation: "password123")
    assert_raises(ActiveRecord::RecordNotUnique) { user.save }
  end

  test "normalizes email to downcase" do
    user = User.new(name: "Test", email_address: "  TEST@Example.COM  ", password: "password123", password_confirmation: "password123")
    user.save!
    assert_equal "test@example.com", user.email_address
  end

  test "has many sessions" do
    assert_respond_to users(:alice), :sessions
  end

  test "has many lesson_completions" do
    assert_respond_to users(:alice), :lesson_completions
  end

  test "has many completed_lessons" do
    assert_includes users(:alice).completed_lessons, lessons(:multi_repo)
  end
end
