class TimesheetsController < ApplicationController
  before_action :signed_in_user, except: [:index, :show]
  before_action :admin_user, only: [:destroy]

  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end

  def show
    @timesheet = Timesheet.includes(entries: :athlete).find(params[:id])
    # Need to include the run under entries
    @entries = @timesheet.entries
  end

  def edit
    @timesheet = Timesheet.find(params[:id])
  end

  def update
    @timesheet = Timesheet.find(params[:id])
    if @timesheet.update_attributes(timesheet_params)
      flash[:success] = "Timesheet updated."
      redirect_to @timesheet
    else
      render 'edit'
    end
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)
    if @timesheet.save
      flash[:success] = "Timesheet created."
      redirect_to @timesheet
    else
      render 'new'
    end
  end

  def destroy
    Timesheet.find(params[:id]).destroy
    flash[:success] = "Timesheet deleted."
    redirect_to timesheets_url
  end

  private
    def timesheet_params
      params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race)
    end
end
