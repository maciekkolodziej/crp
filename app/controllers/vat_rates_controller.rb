class VatRatesController < ApplicationController
  before_action :set_vat_rate, only: [:show, :edit, :update, :destroy]

  def gender
    'male' 
  end

  # GET /vat_rates
  def index
    @vat_rates = VatRate.all
    
    # Actions that are allowed to be executed in batch
    @batch_actions = { batch_destroy: t('delete', default: 'Delete').capitalize }
    @vat_rates_grid = initialize_grid(VatRate, per_page: records_per_page, conditions: current_ability.model_adapter(VatRate, :read).conditions)
  end

  # GET /vat_rates/1
  def show
  end

  # GET /vat_rates/new
  def new
    @vat_rate = VatRate.new
  end

  # GET /vat_rates/1/edit
  def edit
  end

  # POST /vat_rates
  def create
    @vat_rate = VatRate.new(vat_rate_params)

    if @vat_rate.save
      redirect_to @vat_rate, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'VatRate was sucessfully saved.'], model: VatRate.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /vat_rates/1
  def update
    if @vat_rate.update(vat_rate_params)
      redirect_to @vat_rate, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'VatRate was sucessfully saved.'], model: VatRate.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /vat_rates/1
  def destroy
    @vat_rate.destroy
    redirect_to vat_rates_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'VatRate was sucessfully deleted.'], model: VatRate.model_name.human)
  end
  
  # PATCH /vat_rates/batch_destroy
  def batch_destroy
    ids = params[:grid][:selected]
    VatRate.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed.many', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vat_rate
      @vat_rate = VatRate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vat_rate_params
      params.require(:vat_rate).permit(:symbol, :rate)
    end
end
