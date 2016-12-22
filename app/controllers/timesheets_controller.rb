class TimesheetsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :correct_user, if: :personal_timesheet?, only: [:update, :edit, :destroy, :show]
  before_action :admin_user, if: :general_timesheet?, only: [:update, :edit, :destroy]

  before_action :set_track_time_zone, only: [:create, :update]
  before_action :set_track_time_zone_edit, only: [:edit]

  def index
    @timesheets = Timesheet.general.includes(:season, :track).filter(filtering_params).page params[:page]
  end

  def new
    @timesheet = current_user.timesheets.build
    @genders = Timesheet.genders
    @visibilities = Timesheet.visibilities
  end

  def show
    @timesheet = Timesheet.find(params[:id])
    @ranked = @timesheet.ranked_entries
    @best = @timesheet.best_runs
    @runs = @timesheet.ranked_runs if @ranked.present?
    @is_this_timesheet_being_shared = false

    if @timesheet.personal?

      if current_user.has_share_access?(@timesheet)
        @is_this_timesheet_being_shared = true unless @timesheet.user == current_user
      end
    end

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
    @visibilities = Timesheet.visibilities
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
    @timesheet = current_user.timesheets.build(timesheet_params)

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

  def copy
    @timesheet = Timesheet.find(params[:id])
    @genders = Timesheet.genders
    @visibilities = Timesheet.visibilities
    @timesheet = Timesheet.new(@timesheet.attributes)
    render :new
  end

  def chart
    render json: Timesheet.count
  end

  def share
    @timesheet = Timesheet.find(params[:id])
    email_addresses = params[:emails].split(",")
    email_addresses.each do |email|
      @shared_timesheet = current_user.shared_timesheets.new
      @shared_timesheet.timesheet_id = params[:timesheet_id]
      @shared_timesheet.shared_email = email

      shared_user = User.find_by(email: email)
      @shared_timesheet.shared_user_id = shared_user.id if shared_user
      @shared_timesheet.message = params[:message]

      respond_to do |format|
        format.js {
          if @shared_timesheet.save
            UserMailer.invitation_to_share(@shared_timesheet).deliver
          end
        }
      end
    end
  end

  def leave_sharing
    @timesheet = Timesheet.find(params[:id])
    @shared = @timesheet.shared_timesheets.find_by(shared_user_id: current_user.id).destroy
    flash[:success] = "You have left this timesheet."
    redirect_to timesheets_url
  end

  private
    def timesheet_params
      params.require(:timesheet).permit(:name, :nickname, :track_id, :circuit_id, :date, :race, :season_id, :pdf, :gender, :remote_pdf_url, :remove_pdf, :tweet, :status, :visibility, :user_id)
    end

    def correct_user
      # must also take into account shared users
      if current_user
        unless @timesheet.user == current_user || current_user.admin? || current_user.has_share_access?(@timesheet)
          redirect_to timesheets_path, notice: "Sorry, that timesheet doesn't exist"
        end
      else
        redirect_to timesheets_path, notice: "That timesheet doesn't exist"
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

    def personal_timesheet?
      @timesheet = Timesheet.find(params[:id])
      @timesheet.personal?
    end

    def general_timesheet?
      @timesheet = Timesheet.find(params[:id])
      @timesheet.general?
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
