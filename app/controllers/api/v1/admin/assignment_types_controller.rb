class Api::V1::Admin::AssignmentTypesController < Api::V1Controller

  before_action :find_assignment_type, except: [ :index, :create ]

  def index
    @assignment_types = AssignmentType.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @assignment_type.update(assignment_type_params)
      render :show
    else
      render_response(success: false, errors: @assignment_type.errors, status: 200)
    end
  end

  def create
    @assignment_type = AssignmentType.new(assignment_type_params)

    if @assignment_type.save
      render :show
    else
      render_response(success: false, errors: @assignment_type.errors, status: 200)
    end
  end

  def destroy
    if @assignment_type.destroy
      @assignment_types = AssignmentType.all.sort

      render :index
    else
      render_response(success: false, errors: @assignment_type.errors, status: 200)
    end
  end

  private

    def assignment_type_params
      params.permit(:name)
    end

    def find_assignment_type
      @assignment_type = AssignmentType.find(params[:id])
    end

end
