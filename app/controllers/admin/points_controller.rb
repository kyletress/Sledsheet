class Admin::PointsController < AdminController

  def index
    @points = Point.includes(:athlete, :timesheet).all
  end

  def new
    @point = Point.new
  end

  def edit
    @point = Point.find(params[:id])
  end

  def create
    @point = Point.new(point_params)
    if @point.save
      flash[:success] = "Point created."
      redirect_to @point
    else
      render 'new'
    end
  end

  def update
    @point = Point.find(params[:id])
    if @point.update_attributes(point_params)
      flash[:success] = "Point updated"
      redirect_to timesheet_points_path(@point.timesheet)
    else
      render 'edit'
    end
  end

  def destroy
    @point = Point.find(params[:id])
    @point.destroy
    flash[:success] = "Point destroyed."
    redirect_to timesheet_points_path(@point.timesheet)
  end

  private

  def point_params
    params.require(:point).permit(:athlete, :season, :timesheet, :value, :circuit)
  end

end
