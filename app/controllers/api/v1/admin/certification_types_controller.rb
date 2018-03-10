class Api::V1::Admin::CertificationTypesController < Api::V1Controller

  before_action :find_certification_type, except: [ :index, :create ]

  def index
    @certification_types = CertificationType.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @certification_type.update(certification_type_params)
      render :show
    else
      render_response(success: false, errors: @certification_type.errors, status: 200)
    end
  end

  def create
    @certification_type = CertificationType.new(certification_type_params)

    if @certification_type.save
      render :show
    else
      render_response(success: false, errors: @certification_type.errors, status: 200)
    end
  end

  def destroy
    if @certification_type.destroy
      @certification_types = CertificationType.all.sort

      render :index
    else
      render_response(success: false, errors: @certification_type.errors, status: 200)
    end
  end

  private

    def certification_type_params
      params.permit(:name, :effective_interval, :effective_interval_unit)
    end

    def find_certification_type
      @certification_type = CertificationType.find(params[:id])
    end

end
