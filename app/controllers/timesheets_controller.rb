class TimesheetsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :admin_user, only: [:new, :edit, :create, :destroy]

  def index
    @timesheets = Timesheet.includes(:season).all
  end

  def new
    @timesheet = Timesheet.new
  end

  def show
    @timesheet = Timesheet.includes(entries: [:athlete, :runs]).find(params[:id])
    @ranked = @timesheet.ranked_entries
    @unranked = @timesheet.entries
    @best = @timesheet.best_run(1)
    respond_to do |format|
      format.html do
        if current_user
          render 'show_advanced'
        else
          render 'show'
        end
      end
      format.pdf do
        pdf = TimesheetPdf.new(@timesheet, view_context)
        send_data pdf.render, filename: "#{@timesheet.pdf_name}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
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
    # probably not the best place for this, but it's staying for now...
    def time_to_integer(time_str)
      if /[:]/ =~ time_str
        minutes, seconds, centiseconds = time_str.split(/[:.]/).map{|str| str.to_i}
        (minutes * 60 + seconds) * 100 + centiseconds
      else
        time_str.delete('.').to_i
      end
    rescue
      -1
    end
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

      @entry = @timesheet.entries.build(
        :athlete_id => Athlete.find_by_timesheet_name(entry[:name]).first.id
      )
      @entry.save
      if @entry.errors.any?
        @entry.errors.full_messages.each do |e|
          puts e
        end
      end
      entry[:runs].each do |run|
        @run = @entry.runs.build(
          :start => time_to_integer(run[:start]),
          :split2 => time_to_integer(run[:split2]),
          :split3 => time_to_integer(run[:split3]),
          :split4 => time_to_integer(run[:split4]),
          :split5 => time_to_integer(run[:split5]),
          :finish => time_to_integer(run[:finish])
        )
        @run.save
        if @run.errors.any?
        @run.errors.full_messages.each do |e|
          puts e
        end
      end
      end
    end
    redirect_to @timesheet
  end

  private
    def timesheet_params
      params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race, :season_id, :pdf, :remote_pdf_url, :remove_pdf)
    end
end
