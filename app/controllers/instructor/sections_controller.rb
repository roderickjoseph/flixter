class Instructor::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: %i[new create]
  before_action :require_authorized_for_current_section, only: [:update]

  def new
    @section = Section.new
  end

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.update_attributes(section_params)
    render text: 'updated!'
  end

  private

  def require_authorized_for_current_section
    render text: 'Unauthorized - section', status: :unauthorized unless
    current_section.course.user == current_user
  end

  def require_authorized_for_current_course
    render text: 'Unauthorized - course', status: :unauthorized unless
    current_course.user == current_user
  end

  helper_method :current_course

  def current_course
    if params[:course_id]
      @current_course ||= Course.find(params[:course_id])
    else
      current_section.course
    end
  end

  def section_params
    params.require(:section).permit(:title, :row_order_position)
  end
end
