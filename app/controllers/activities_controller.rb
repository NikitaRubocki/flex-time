class ActivitiesController < ApplicationController

  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @week_offset = params[:week_offset]&.to_i || 0
    day_offset = @week_offset * 7
    @activities = {
      Date.today.monday + 1 + day_offset => Activity.where(date: Date.today.monday + 1 + day_offset),
      Date.today.monday + 3 + day_offset => Activity.where(date: Date.today.monday + 3 + day_offset),
      Date.today.monday + 4 + day_offset => Activity.where(date: Date.today.monday + 4 + day_offset)
    }
  end

  def show; end

  def new
    @activity = Activity.new(humanized_date: params[:date])
    monday_of_week = params[:date].to_date.monday
    @dates = [
      [I18n.l(monday_of_week + 1, format: :complete), monday_of_week + 1],
      [I18n.l(monday_of_week + 3, format: :complete), monday_of_week + 3],
      [I18n.l(monday_of_week + 4, format: :complete), monday_of_week + 4]
    ]
  end

  def edit
    @dates = [
      [I18n.l(@activity.date.monday + 1, format: :complete), @activity.date.monday + 1],
      [I18n.l(@activity.date.monday + 3, format: :complete), @activity.date.monday + 3],
      [I18n.l(@activity.date.monday + 4, format: :complete), @activity.date.monday + 4]
    ]
  end

  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_activity
      @activity = Activity.find(params[:id])
    end


    def activity_params
      params.require(:activity).permit(:name, :room, :capacity, :date, :humanized_date)
    end

end
