class Api::V1::Admin::RacesController < Api::V1Controller

  before_action :find_race, except: [ :index, :create ]

  def index
    @races = Race.all.sort

    render :index
  end

  def show
    render :show
  end

  def update
    if @race.update(race_params)
      render :show
    else
      render_response(success: false, errors: @race.errors, status: 200)
    end
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      render :show
    else
      render_response(success: false, errors: @race.errors, status: 200)
    end
  end

  def destroy
    if @race.destroy
      @races = Race.all.sort

      render :index
    else
      render_response(success: false, errors: @race.errors, status: 200)
    end
  end

  private

    def race_params
      params.permit(:name)
    end

    def find_race
      @race = Race.find(params[:id])
    end

end
