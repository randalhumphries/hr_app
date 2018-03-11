class Api::V1::EmployeesController < Api::V1Controller

  before_action :find_employee, except: [ :index, :create ]

  def index
    @employees = Employee.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @employee.update(employee_params)
      render :show
    else
      render_response(success: false, errors: @employee.errors, status: 200)
    end
  end

  def create
    @employee = Person.find(params[:person_id]).build_employee(employee_params)

    if @employee.save
      render :show
    else
      render_response(success: false, errors: @employee.errors, status: 200)
    end
  end

  def destroy
    if @employee.destroy
      @employees = Employee.all.sort

      render :index
    else
      render_response(success: false, errors: @employee.errors, status: 200)
    end
  end

  private

    def employee_params
      params.permit(:active, :temp_hire_at, :full_time_hire_at, :person_id)
    end

    def find_employee
      @employee = Employee.find(params[:id])
    end

end
