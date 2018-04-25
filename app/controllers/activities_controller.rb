class ActivitiesController < ApplicationController

  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_date, only: [:index, :new, :destroy]
  before_action :restrict_unless_admin, only: [:destroy, :copy]

  def index
    @week_of_activities = Activity.for_week(@date)
  end

  def show; end

  def new
    @activity = Activity.new(date: @date)
    @dates_for_select = [
      [I18n.l(@activity.date.tuesday, format: :complete), @activity.date.tuesday],
      [I18n.l(@activity.date.thursday, format: :complete), @activity.date.thursday],
      [I18n.l(@activity.date.friday, format: :complete), @activity.date.friday]
    ]
  end

  def edit
    @dates_for_select = [
      [I18n.l(@activity.date.tuesday, format: :complete), @activity.date.tuesday],
      [I18n.l(@activity.date.thursday, format: :complete), @activity.date.thursday],
      [I18n.l(@activity.date.friday, format: :complete), @activity.date.friday]
    ]
  end

  def create
    @activity = Activity.new(activity_params)
    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        @dates_for_select = [
          [I18n.l(@activity.date.tuesday, format: :complete), @activity.date.tuesday],
          [I18n.l(@activity.date.thursday, format: :complete), @activity.date.thursday],
          [I18n.l(@activity.date.friday, format: :complete), @activity.date.friday]
        ]
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy
    begin
      from = params[:from].to_date
      to = params[:to].to_date
      Activity.copy!(from, to)
      redirect_to activities_path(date: to.monday), notice: 'Activities were successfully copied.'
    rescue
      redirect_to activities_path(date: to.monday), alert: 'There was a problem copying the activities.'
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        @dates_for_select = [
          [I18n.l(@activity.date.tuesday, format: :complete), @activity.date.tuesday],
          [I18n.l(@activity.date.thursday, format: :complete), @activity.date.thursday],
          [I18n.l(@activity.date.friday, format: :complete), @activity.date.friday]
        ]
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url(date: @date), notice: "#{@activity.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

    def set_activity
      @activity = Activity.find_with_registration_student_and_teacher(params[:id])
    end

    # The controller's index and new actions typically expect a date parameter,
    # used to determine 1) the week of the schedule to display and 2) which date
    # option to mark as selected in the activity form.
    # When there is a date, use it. Otherwise, use the beginning of the week.
    def set_date
      @date = if params[:date] =~ /^\d{4}-\d{2}-\d{2}$/
        params[:date].to_date
      else
        Date.today.beginning_of_week
      end
    end

    def activity_params
      params.require(:activity).permit(:name, :room, :capacity, :date)
    end

end
