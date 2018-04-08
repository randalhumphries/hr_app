class Api::V1::Admin::CompanyUnitsController < Api::V1Controller

  before_action :find_company_unit, except: [ :index, :create ]

  def index
    @company_units = CompanyUnit.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @company_unit.update(company_unit_params)
      render :show
    else
      render_response(success: false, errors: @company_unit.errors, status: 200)
    end
  end

  def create
    @company_unit = Company.find(params[:company_id]).company_units.build(company_unit_params)

    if @company_unit.save
      render :show
    else
      render_response(success: false, errors: @company_unit.errors, status: 200)
    end
  end

  def destroy
    if @company_unit.destroy
      @company_units = CompanyUnit.all.sort

      render :index
    else
      render_response(success: false, errors: @company_unit.errors, status: 200)
    end
  end

  private

    def company_unit_params
      params.permit(:name, :company_id, :manager)
    end

    def find_company_unit
      @company_unit = CompanyUnit.find(params[:id])
    end

end
