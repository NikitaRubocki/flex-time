class StudentsController < ApplicationController

  skip_before_action :restrict_from_students, only: :show
  before_action :set_student, only: [:show, :update]

  def index
    @students = User.student
  end

  def show
    @activities = {
      Date.today.tuesday => Activity.first,
      Date.today.thursday => Activity.first,
      Date.today.friday => Activity.first
    }
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_student
      @student = current_user.student? ? current_user : User.find(params[:id])
    end

    def student_params
      params.fetch(:student, {})
    end

end
