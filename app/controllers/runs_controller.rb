class RunsController < ApplicationController
  before_action :load_entry_and_timesheet, except: [:edit, :update, :destroy]
  # before_action :admin_user, only: [:new, :edit, :create, :destroy]
  before_action :authorize_user

  # if you are an admin, you can add a run
  # if this is your timesheet, you can add a run
  # if you have sharing permission (admin level) you can add a run.
  # else redirect

  def new
    @run = @entry.runs.new
    @statuses = Run.statuses
  end

  def show
  end

  def edit
    @run = Run.find(params[:id])
    @statuses = Run.statuses
  end

  def create
    @run = @entry.runs.build(run_params)
    @run.position = @run.entry.runs.count + 1
    if @run.save
      flash[:success] = "Run added."
      redirect_to timesheet_path(@entry.timesheet)
    else
      render 'new'
    end
  end

  def update
    @run = Run.find(params[:id])
    if @run.update_attributes(run_params)
      flash[:success] = "Run updated."
      redirect_to @run.entry.timesheet
    else
      render 'edit'
    end
  end

  def destroy
    @run = Run.find(params[:id])
    @run.destroy
    redirect_to timesheet_path(@run.entry.timesheet), notice: "Run destroyed"
  end

  private

    def run_params
      params.require(:run).permit(:entry_id, :start, :split2, :split3, :split4, :split5, :finish, :status)
    end

    def load_entry_and_timesheet
      @entry = Entry.find(params[:entry_id])
      @timesheet = @entry.timesheet
    end

    def authorize_user
      if current_user
        unless @timesheet.user == current_user || current_user.admin?# || current_user.has_share_access?(@timesheet)
          redirect_to timesheet_path(@timesheet), alert: "Sorry, you don't have permission to do that."
        end
      else
        redirect_to timesheet_path(@timesheet), alert: "Sorry, you don't have permissino to do that."
      end
    end
end
