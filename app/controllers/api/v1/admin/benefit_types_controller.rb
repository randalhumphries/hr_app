class Api::V1::Admin::BenefitTypesController < Api::V1Controller

  before_action :find_benefit_type, except: [ :index, :create ]

  def index
    @benefit_types = BenefitType.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @benefit_type.update(benefit_type_params)
      render :show
    else
      render_response(success: false, errors: @benefit_type.errors, status: 200)
    end
  end

  def create
    @benefit_type = BenefitType.new(benefit_type_params)

    if @benefit_type.save
      render :show
    else
      render_response(success: false, errors: @benefit_type.errors, status: 200)
    end
  end

  def destroy
    if @benefit_type.destroy
      @benefit_types = BenefitType.all.sort

      render :index
    else
      render_response(success: false, errors: @benefit_type.errors, status: 200)
    end
  end

  private

    def benefit_type_params
      params.permit(:name, :eligibility_interval, :eligibility_interval_unit)
    end

    def find_benefit_type
      @benefit_type = BenefitType.find(params[:id])
    end

end
