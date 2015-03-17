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
  
  def import
    require 'nokogiri'
    require 'open-uri'
    @timesheet = Timesheet.find(params[:id])
    url = params[:url]
    doc = Nokogiri::HTML(open(url))
    doc.css(".list-table") 
    trs = doc.css('.padding1010, .facts').to_a
    entries = trs.slice_before{ |elm| elm.attr('class') =='padding1010' }.to_a
 
    entries.map! do |entry|
      {
       name: entry.shift.at_css('a.blue').text,
       runs: entry.select{ |tr| tr.attr('class') == 'facts' }.map do |run|
         {
           start: run.css('td')[1].text,
           split2: run.css('td')[2].text,
           split3: run.css('td')[3].text,
           split4: run.css('td')[4].text,
           split5: run.css('td')[5].text,
           finish: run.css('td')[6].text[/([0-1]:[0-5][0-9].[0-9][0-9])|[0-5][0-9].[0-9][0-9]/]
         }
        end
      }
    end
    
    entries.each do |entry|
      # create a new timesheet entry for each of these
      
      @entry = @timesheet.entries.build(
        :athlete_id => Athlete.find_by_timesheet_name(entry[:name]).first.id
      )
      @entry.save
      if @entry.errors.any?
        @entry.errors.full_messages.each do |e|
          puts e
        end
      end
    end
    redirect_to @timesheet
  end

  private
    def timesheet_params
      params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race)
    end
end
