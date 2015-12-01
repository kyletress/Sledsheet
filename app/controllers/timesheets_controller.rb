class TimesheetsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :admin_user, only: [:new, :edit, :create, :destroy]

  def index
    @timesheets = Timesheet.includes(:season).filter(filtering_params).page params[:page]
  end

  def new
    @timesheet = Timesheet.new
    @genders = Timesheet.genders
  end

  def show
    @timesheet = Timesheet.find(params[:id])
    @ranked = @timesheet.ranked_entries
    @intermediates = @timesheet.ranked_intermediates
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
    @genders = Timesheet.genders
  end

  def update
    @timesheet = Timesheet.find(params[:id])
    if @timesheet.update_attributes(timesheet_params)
      if params[:tweet].present?
        tweet_timesheet
      end
      award_points
      flash[:success] = "Timesheet updated."
      redirect_to @timesheet
    else
      render 'edit'
    end
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)
    if @timesheet.save
      if params[:tweet].present?
        tweet_timesheet
      end
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
    def time_to_integer(time_str)
      if /[:]/ =~ time_str
        minutes, seconds, centiseconds = time_str.split(/[:.]/).map{|str| str.to_i}
        (minutes * 60 + seconds) * 100 + centiseconds
      else
        time_str.delete('.').to_i
      end
    rescue
      99999 # make it absurdly high to prevent ranking errors
    end
    @timesheet = Timesheet.find(params[:id])
    url = params[:url]
    page = Nokogiri::HTML(open(url))
    page.css(".table")
    trs = page.css('.crew, .run').to_a
    entries = trs.slice_before{ |elm| elm.attr('class') =='crew' }.to_a

    entries.map! do |entry|
      {
        name: entry.at(0).css("td.visible-xs div.fl.athletes a").text.strip,
        country: entry.at(0).css("div.fl.athletes img.country-flag").attr('alt').text,
        runs: entry.select{ |tr| tr.attr('class') == 'run' }.map do |run|
          {
            start: run.css('td')[1].text.strip,
            split2: run.css('td')[2].text.strip,
            split3: run.css('td')[3].text.strip,
            split4: run.css('td')[4].text.strip,
            split5: run.css('td')[5].text.strip,
            finish: run.css('td')[6].text.strip
          }
        end
      }
    end

    entries.each do |entry|

      @entry = @timesheet.entries.build(
        #:athlete_id => Athlete.find_by_timesheet_name(entry[:name]).first.id
        athlete: Athlete.find_or_create_by_timesheet_name(entry[:name], entry[:country], @timesheet.gender)
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
      params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race, :season_id, :pdf, :gender, :remote_pdf_url, :remove_pdf, :tweet, :status)
    end

    def award_points
      @timesheet = Timesheet.find(params[:id])
      if @timesheet.race && @timesheet.complete
        @timesheet.award_points
      end
    end

    def filtering_params
      params.slice(:type, :track, :circuit, :gender, :season)
    end

    def tweet_timesheet
      twitter = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
      end
      twitter.update("#{@timesheet.name}: http://www.sledsheet.com/timesheets/#{@timesheet.id}")
    end
end
