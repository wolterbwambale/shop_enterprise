class OutletTypesController < ApplicationController
  def index
    @outlet_types = OutletType.all
  end

  def show
    @outlet_type = OutletType.find(params[:id])
  end

  def new
    @outlet_type = OutletType.new
  end

  def create
    @outlet_type = OutletType.new(outlet_type_params)

    if @outlet_type.save
      redirect_to @outlet_type
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @outlet_type = OutletType.find(params[:id])
  end

  def update
    @outlet_type = OutletType.find(params[:id])
    if @outlet_type.update(outlet_type_params)
      redirect_to @outlet_type
    else 
      render :edit, status: :unprocessable_entity
  end
end

def destroy
  @outlet_type = OutletType.find(params[:id])
  @outlet_type.destroy
  redirect_to root_path, status: :see_other
end

  private
  def outlet_type_params
  params.require(:outlet_type).permit(:name)
  end

end
