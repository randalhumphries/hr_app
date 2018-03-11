class Api::V1::PeopleController < Api::V1Controller

  before_action :find_person, except: [ :index, :create ]

  def index
    @people = Person.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @person.update(person_params)
      render :show
    else
      render_response(success: false, errors: @person.errors, status: 200)
    end
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      render :show
    else
      render_response(success: false, errors: @person.errors, status: 200)
    end
  end

  def destroy
    if @person.destroy
      @people = Person.all.sort

      render :index
    else
      render_response(success: false, errors: @person.errors, status: 200)
    end
  end

  private

    def person_params
      params.permit(:first_name, :middle_name, :last_name, :prefix, :suffix, :date_of_birth)
    end

    def find_person
      @person = Person.find(params[:id])
    end

end
