class Api::V1::AddressesController < Api::V1Controller

  before_action :find_address, except: :create

  def index
    render :show
  end

  def show
    render :show
  end

  def update
    if @address.update(address_params)
      render :show
    else
      render_response(success: false, errors: @address.errors, status: 200)
    end
  end

  def create
    @address = Person.find(params[:person_id]).build_address(address_params)

    if @address.save
      render :show
    else
      render_response(success: false, errors: @address.errors, status: 200)
    end
  end

  def destroy
    if @address.destroy
      find_address
      render :show
    else
      render_response(success: false, errors: @address.errors, status: 200)
    end
  end

  private

    def address_params
      params.permit(:person_id, :address_1, :address_2, :city, :state, :zip, :country)
    end

    def find_address
      @address = Person.find(params[:person_id]).address
    end
end
