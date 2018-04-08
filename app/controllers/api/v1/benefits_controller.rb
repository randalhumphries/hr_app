class Api::V1::BenefitsController < Api::V1Controller

  before_action :find_employee
  before_action :find_benefit, except: [ :index, :create ]

  def index
    @benefits = @employee.benefits.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @benefit.update(benefit_params)
      render :show
    else
      render_response(success: false, errors: @benefit.errors, status: 200)
    end
  end

  def create
    @benefit = @employee.benefits.new(benefit_params)

    if @benefit.save
      render :show
    else
      render_response(success: false, errors: @benefit.errors, status: 200)
    end
  end

  def destroy
    if @benefit.destroy
      @benefits = @employee.benefits.sort

      render :index
    else
      render_response(success: false, errors: @benefit.errors, status: 200)
    end
  end

  private

    def benefit_params
      params.permit(:employee_id, :benefit_type_id, :eligible_at, :notified_at, :updated_by, :notes)
    end

    def find_employee
      @employee = Employee.find(params[:employee_id])
    end

    def find_benefit
      @benefit = @employee.benefits.find(params[:id])
    end
end
