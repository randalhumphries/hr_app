class Api::V1::Admin::RelationshipTypesController < Api::V1Controller

  before_action :find_relationship_type, except: [ :index, :create ]

  def index
    @relationship_types = RelationshipType.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @relationship_type.update(relationship_type_params)
      render :show
    else
      render_response(success: false, errors: @relationship_type.errors, status: 200)
    end
  end

  def create
    @relationship_type = RelationshipType.new(relationship_type_params)

    if @relationship_type.save
      render :show
    else
      render_response(success: false, errors: @relationship_type.errors, status: 200)
    end
  end

  def destroy
    if @relationship_type.destroy
      @relationship_types = RelationshipType.all.sort

      render :index
    else
      render_response(success: false, errors: @relationship_type.errors, status: 200)
    end
  end

  private

    def relationship_type_params
      params.permit(:name)
    end

    def find_relationship_type
      @relationship_type = RelationshipType.find(params[:id])
    end

end
