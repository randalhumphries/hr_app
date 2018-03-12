class Api::V1::ContactsController < Api::V1Controller

  before_action :find_contact, except: [ :index, :create ]

  def index
    @contacts = Contact.all.sort

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
    @contact = Person.find(params[:person_id]).contacts.build(contact_params)

    if @contact.save
      render :show
    else
      render_response(success: false, errors: @contact.errors, status: 200)
    end
  end

  def destroy
    if @contact.destroy
      @contacts = Contact.all.sort

      render :index
    else
      render_response(success: false, errors: @contact.errors, status: 200)
    end
  end

  private

    def contact_params
      params.permit(:contact, :person_id, :contact_type_id)
    end

    def find_contact
      @contact = Contact.find(params[:id])
    end

end
