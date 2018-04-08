class Api::V1::Admin::ContactTypesController < Api::V1Controller

  before_action :find_contact_type, except: [ :index, :create ]

  def index
    @contact_types = ContactType.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @contact_type.update(contact_type_params)
      render :show
    else
      render_response(success: false, errors: @contact_type.errors, status: 200)
    end
  end

  def create
    @contact_type = ContactType.new(contact_type_params)

    if @contact_type.save
      render :show
    else
      render_response(success: false, errors: @contact_type.errors, status: 200)
    end
  end

  def destroy
    if @contact_type.destroy
      @contact_types = ContactType.all.sort

      render :index
    else
      render_response(success: false, errors: @contact_type.errors, status: 200)
    end
  end

  private

    def contact_type_params
      params.permit(:name)
    end

    def find_contact_type
      @contact_type = ContactType.find(params[:id])
    end
end
