class TimesheetsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :load_timesheet, only: [:copy,:show,:edit,:update,:destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :allowed_user, only: [:show]
  before_action :set_track_time_zone, only: [:create, :update]
  before_action :set_track_time_zone_edit, only: [:edit]

  def index
    @timesheets = PublicTimesheet.all.includes(:season, :track).filter(filtering_params).page params[:page]
  end

  def new
    @timesheet = current_user.timesheets.build
  end

  def show
    @ranked = @timesheet.ranked_entries
    @best = @timesheet.best_runs
    @runs = @timesheet.ranked_runs if @ranked.present?
    respond_to do |format|
      format.html do
        # if current_user
          render 'show_advanced'
        # else
        #   render 'show'
        # end
      end
      format.pdf do
        pdf = TimesheetPdf.new(@timesheet, view_context)
        send_data pdf.render, filename: "#{@timesheet.pdf_name}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def edit
    @genders = Timesheet.genders
  end

  def update
    if @timesheet.update_attributes(timesheet_params)
      if params[:tweet].present?
        tweet_timesheet
      end
      award_points
      flash[:success] = "Timesheet updated."
      redirect_to timesheet_path(@timesheet) # error here.
    else
      render 'edit'
    end
  end

  def create
    @timesheet = current_user.private_timesheets.build(timesheet_params)
    if @timesheet.save
      # Notification.create(recipient: current_user, actor: current_user, action: "posted", notifiable: @timesheet)
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
    @timesheet.destroy
    flash[:success] = "Timesheet deleted."
    redirect_to timesheets_url
  end

  def copy
    @genders = Timesheet.genders
    @timesheet = Timesheet.new(@timesheet.attributes)
    render :new
  end

  def chart
    render json: Timesheet.count
  end

  private
    def timesheet_params
      params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race, :season_id, :pdf, :gender, :remote_pdf_url, :remove_pdf, :tweet, :status, :visibility, :user_id)
    end

    def load_timesheet
      @timesheet = Timesheet.friendly.find(params[:id])
    end

    def correct_user
      redirect_to timesheets_url unless @timesheet.editable?(current_user)
    end

    def allowed_user
      if @timesheet.personal?
        redirect_to timesheets_url unless current_user && @timesheet.visible?(current_user)
      end
    end

    def set_track_time_zone
      if params[:timesheet][:track_id]
        track = Track.find(params[:timesheet][:track_id])
        Time.zone = track.time_zone
      end
    end

    def set_track_time_zone_edit
      Time.zone = @timesheet.track.time_zone
    end

    def award_points
      @timesheet = Timesheet.friendly.find(params[:id])
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
