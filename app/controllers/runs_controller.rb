class RunsController < ApplicationController
  before_action :load_entry_and_timesheet, except: [:edit, :update, :destroy]

  def new
    @run = @entry.runs.new
  end

  def show
  end

  def edit
    @run = Run.find(params[:id])
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
      params.require(:run).permit(:entry_id, :start, :split2, :split3, :split4, :split5, :finish)
    end

  def load_entry_and_timesheet
      @entry = Entry.find(params[:entry_id])
      @timesheet = @entry.timesheet
    end
end
