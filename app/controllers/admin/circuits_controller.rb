class Admin::CircuitsController < AdminController

  before_action :load_circuit, only: [:update, :show, :edit, :destroy]

  def index
    @circuits = Circuit.all
  end

  def show
  end

  def new
    @circuit = Circuit.new
  end

  def edit
  end

  def update
    if @circuit.update_attributes(circuit_params)
      flash[:success] = "Circuit updated"
      redirect_to admin_circuits_path
    else
      render 'edit'
    end
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
    @circuit.destroy
    flash[:success] = "Circuit has been deleted."
    redirect_to admin_circuits_url
  end

  private

    def circuit_params
      params.require(:circuit).permit(:name, :nickname, :slug)
    end

    def load_circuit
      @circuit = Circuit.friendly.find(params[:id])
    end

end
