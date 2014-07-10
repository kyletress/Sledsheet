class EntriesController < ApplicationController
  before_action :find_timesheet

  def index
    @entries = @timesheet.entries
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = @timesheet.entries.build(entry_params)
    if @entry.save
      flash[:success] = "#{@entry.athlete.name} has been added to the timesheet."
      redirect_to timesheet_entries_path(@timesheet)
    else
      render 'new'
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    flash[:success] = "Entry deleted."
    redirect_to timesheet_entries_path(@timesheet)
  end

  private

    def entry_params
      params.require(:entry).permit(:athlete_id, :timesheet_id)
    end

    def find_timesheet
      @timesheet = Timesheet.find(params[:timesheet_id])
    end

end
