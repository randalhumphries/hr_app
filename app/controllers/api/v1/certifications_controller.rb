class Api::V1::CertificationsController < Api::V1Controller

  before_action :find_person
  before_action :find_certification, except: [ :index, :create ]

  def index
    @certifications = @person.certifications.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @certification.update(certification_params)
      render :show
    else
      render_response(success: false, errors: @certification.errors, status: 200)
    end
  end

  def create
    @certification = @person.certifications.new(certification_params)

    if @certification.save
      render :show
    else
      render_response(success: false, errors: @certification.errors, status: 200)
    end
  end

  def destroy
    if @certification.destroy
      @certifications = @person.certifications.sort

      render :index
    else
      render_response(success: false, errors: @certification.errors, status: 200)
    end
  end

  private

    def certification_params
      params.permit(:person_id, :certification_type_id, :certification_number, :renewed_at, :expires_at, :updated_by)
    end

    def find_person
      @person = Person.find(params[:person_id])
    end

    def find_certification
      @certification = @person.certifications.find(params[:id])
    end
end
