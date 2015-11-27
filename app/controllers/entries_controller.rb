class EntriesController < ApplicationController
  before_action :find_timesheet, except: [:destroy, :typeahead]

  def index
    @entries = @timesheet.entries.includes(:athlete).order("bib")
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
    @entry = Entry.find(params[:id])
    @entry.destroy
    flash[:success] = "Entry deleted."
    redirect_to timesheet_entries_path(@entry.timesheet)
  end

  def sort
    params[:entry].each_with_index do |id, index|
      Entry.update_all({bib: index+1}, {id: id})
    end
  end

  private

    def entry_params
      params.require(:entry).permit(:athlete_id, :timesheet_id, :bib, :status)
    end

    def find_timesheet
      @timesheet = Timesheet.find(params[:timesheet_id])
    end

end
