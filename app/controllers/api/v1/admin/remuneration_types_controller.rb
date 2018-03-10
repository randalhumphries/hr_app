class Api::V1::Admin::RemunerationTypesController < Api::V1Controller

  before_action :find_remuneration_type, except: [ :index, :create ]

  def index
    @remuneration_types = RemunerationType.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @remuneration_type.update(remuneration_type_params)
      render :show
    else
      render_response(success: false, errors: @remuneration_type.errors, status: 200)
    end
  end

  def create
    @remuneration_type = RemunerationType.new(remuneration_type_params)

    if @remuneration_type.save
      render :show
    else
      render_response(success: false, errors: @remuneration_type.errors, status: 200)
    end
  end

  def destroy
    if @remuneration_type.destroy
      @remuneration_types = RemunerationType.all.sort

      render :index
    else
      render_response(success: false, errors: @remuneration_type.errors, status: 200)
    end
  end

  private

    def remuneration_type_params
      params.permit(:name, :pay_period_hours, :annual_pay_periods)
    end

    def find_remuneration_type
      @remuneration_type = RemunerationType.find(params[:id])
    end

end
