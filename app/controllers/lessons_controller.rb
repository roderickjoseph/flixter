class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_enrollment_to_view, only: [:show]
  # To use in the views + controller
  helper_method :current_lesson

  def show
  end

  private

  def current_course
    @current_course = current_lesson.section.course
  end

  def require_enrollment_to_view
    redirect_to course_path(current_course), alert: 'You are not enrolled in this course' unless
    current_user.enrolled_in?(current_course)
  end

  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end
end
