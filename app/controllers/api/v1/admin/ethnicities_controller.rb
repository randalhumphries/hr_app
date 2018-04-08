class Api::V1::Admin::EthnicitiesController < Api::V1Controller

  before_action :find_ethnicity, except: [ :index, :create ]

  def index
    @ethnicities = Ethnicity.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @ethnicity.update(ethnicity_params)
      render :show
    else
      render_response(success: false, errors: @ethnicity.errors, status: 200)
    end
  end

  def create
    @ethnicity = Ethnicity.new(ethnicity_params)

    if @ethnicity.save
      render :show
    else
      render_response(success: false, errors: @ethnicity.errors, status: 200)
    end
  end

  def destroy
    if @ethnicity.destroy
      @ethnicities = Ethnicity.all.sort

      render :index
    else
      render_response(success: false, errors: @ethnicity.errors, status: 200)
    end
  end

  private

    def ethnicity_params
      params.permit(:name)
    end

    def find_ethnicity
      @ethnicity = Ethnicity.find(params[:id])
    end
end
