class Api::V1::ContactsController < Api::V1Controller

  before_action :find_person
  before_action :find_contact, except: [ :index, :create ]

  def index
    @contacts = @person.contacts.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @contact.update(contact_params)
      render :show
    else
      render_response(success: false, errors: @contact.errors, status: 200)
    end
  end

  def create
    @contact = @person.contacts.build(contact_params)

    if @contact.save
      render :show
    else
      render_response(success: false, errors: @contact.errors, status: 200)
    end
  end

  def destroy
    if @contact.destroy
      @contacts = @person.contacts.sort

      render :index
    else
      render_response(success: false, errors: @contact.errors, status: 200)
    end
  end

  private

    def contact_params
      params.permit(:contact, :person_id, :contact_type_id)
    end

    def find_person
      @person = Person.find(params[:person_id])
    end

    def find_contact
      @contact = @person.contacts.find(params[:id])
    end

end
