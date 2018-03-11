class Api::V1::Admin::CompaniesController < Api::V1Controller

  before_action :find_company, except: [ :index, :create ]

  def index
    @companies = Company.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @company.update(company_params)
      render :show
    else
      render_response(success: false, errors: @company.errors, status: 200)
    end
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      render :show
    else
      render_response(success: false, errors: @company.errors, status: 200)
    end
  end

  def destroy
    if @company.destroy
      @companies = Company.all.sort

      render :index
    else
      render_response(success: false, errors: @company.errors, status: 200)
    end
  end

  private

    def company_params
      params.permit(:name)
    end

    def find_company
      @company = Company.find(params[:id])
    end

end
