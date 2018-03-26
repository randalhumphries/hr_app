class Api::V1::EmergencyContactsController < Api::V1Controller

  before_action :find_person

  def index
    @emergency_contacts = @person.emergency_contacts.sort

    render :index
  end

  def show
    @emergency_contact = @person.emergency_contacts.find(params[:id])
    
    render :show
  end

  def update
    @emergency_contact = @person.emergency_contacts.find(params[:id])

    if @emergency_contact.update(emergency_contact_params)
      render :show
    elsif
      render_response(success: false, errors: @emergency_contact.errors, status: 200)
    end
  end

  def create
    @emergency_contact = @person.emergency_contacts.create(emergency_contact_params)

    if @emergency_contact.save
      render :show
    else
      render_response(success: false, errors: @emergency_contact.errors, status: 200)
    end
  end

  def destroy
    @emergency_contact = @person.emergency_contacts.find(params[:id])

    if @emergency_contact.destroy
      @emergency_contacts = @person.emergency_contacts.sort

      render :index
    else
      render_response(success: false, errors: @emergency_contact.errors, status: 200)
    end
  end

  private

    def emergency_contact_params
      params.permit(:first_name, :last_name, :contact, :relationship_type_id, :contact_type_id)
    end

    def find_person
      @person = Person.find(params[:person_id])
    end

end