class Admin::UnitsController < ApplicationController
  before_action :set_build, only: [:index, :edit, :new, :create, :purchase]
  before_action :set_unit, only: [:show, :edit, :update, :destroy, :purchase]
  respond_to :html, :json, :js

  # GET /admin/units
  # GET /admin/units.json

  def purchase
      
  end

  def index
    @units = Unit.all
  end

  # GET /admin/units/1
  # GET /admin/units/1.json
  def show
  end

  # GET /admin/units/new
  def new
    @unit = Unit.new
  end

  # GET /admin/units/1/edit
  def edit
    respond_with(@unit)
  end

  # POST /admin/units
  # POST /admin/units.json
  def create
    @unit = Unit.new(admin_unit_params)
    respond_to do |format|
      if @unit.save
        format.html { redirect_to admin_builds_path, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
        format.js {  }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
        format.js {  }
      end
    end
  end

  # PATCH/PUT /admin/units/1
  # PATCH/PUT /admin/units/1.json
  def update
    respond_to do |format|
      if @unit.update(admin_unit_params)
        format.html { redirect_to admin_builds_path, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
        format.js { }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  # DELETE /admin/units/1
  # DELETE /admin/units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to admin_builds_path, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_build
      @build = Build.find(params[:build_id])
    end

    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_unit_params
      params.require(:unit).permit(:name, :value, :size, :build_id, :garage, :brokerage, :deadline, :registry, :incorporation)
    end
end
