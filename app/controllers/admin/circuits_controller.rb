class Admin::CircuitsController < AdminController
  
  def index
    @circuits = Circuit.all
  end
  
  def show
    @circuits = Circuit.find(params[:id])
  end
  
  def new
    @circuit = Circuit.new
  end
  
  def create
    @circuit = Circuit.new(circuit_params)
    if @circuit.save
      flash[:success] = "Circuit created."
      redirect_to @circuit
    else
      render 'new'
    end
  end
  
  def destroy
    Circuit.find(params[:id]).destroy
    flash[:success] = "Circuit has been deleted."
    redirect_to admin_circuits_url
  end
  
  private
  
    def circuit_params
      params.require(:circuit).permit(:name)
    end
  
end