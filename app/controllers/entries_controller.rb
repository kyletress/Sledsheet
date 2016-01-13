class EntriesController < ApplicationController
  before_action :find_timesheet, except: [:destroy, :edit, :update]

  def index
    @entry = Entry.new
    @entries = @timesheet.entries.includes(:athlete).order("bib")
  end

  def new
    @entry = Entry.new
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(entry_params)
      flash[:success] = "Entry updated."
      redirect_to @entry.timesheet
    else
      render 'edit'
    end
  end

  def create
    @entry = @timesheet.entries.build(entry_params)
    #respond_to :html, :js
    respond_to do |format|
      if @entry.save
        format.html {
          flash[:success] = "#{@entry.athlete.name} has been added to the timesheet."
          redirect_to timesheet_entries_path(@timesheet)
        }
        format.js
      else
        render 'new'
      end
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    flash[:success] = "Entry deleted."
    redirect_to timesheet_entries_path(@entry.timesheet)
  end

  def sort
    puts params[:entry]
    params[:entry].each_with_index do |id, index|
      #Entry.update_all({bib: index+1}, {id: id})
      Entry.find(id).update_attribute(:bib,index+1)
    end
    render :nothing => true
  end

  private

    def entry_params
      params.require(:entry).permit(:athlete_id, :timesheet_id, :bib, :status)
    end

    def find_timesheet
      @timesheet = Timesheet.find(params[:timesheet_id])
    end

end
