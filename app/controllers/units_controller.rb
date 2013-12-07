class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'female' 
  end
  
  def import
    Unit.destroy_all
    CrpProductUom.all.each do |uom|
      unit = Unit.new(id: uom.id, symbol: uom.symbol, name: uom.name, primary: uom.primary).save
    end
  end
  
  # GET /units
  def index
    @units = Unit.all
    @units_grid = initialize_grid(Unit, per_page: records_per_page, conditions: current_ability.model_adapter(Unit, :read).conditions, name: 'units_grid')
  end

  # GET /units/1
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to @unit, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Unit was sucessfully saved.'], model: Unit.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /units/1
  def update
    if @unit.update(unit_params)
      redirect_to @unit, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Unit was sucessfully saved.'], model: Unit.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /units/1
  def destroy
    @unit.destroy
    redirect_to units_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'Unit was sucessfully deleted.'], model: Unit.model_name.human)
  end
  
  # PATCH /units/batch_destroy
  def batch_destroy
    ids = params[:units_grid][:selected]
    Unit.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_params
      params.require(:unit).permit(:symbol, :name, :primary)
    end
end
