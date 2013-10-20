class VatRatesController < ApplicationController
  before_action :set_vat_rate, only: [:show, :edit, :update, :destroy]

  # GET /vat_rates
  # GET /vat_rates.json
  def index
    @vat_rates = VatRate.all
  end

  # GET /vat_rates/1
  # GET /vat_rates/1.json
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
  # POST /vat_rates.json
  def create
    @vat_rate = VatRate.new(vat_rate_params)

    respond_to do |format|
      if @vat_rate.save
        format.html { redirect_to @vat_rate, notice: 'Vat rate was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vat_rate }
      else
        format.html { render action: 'new' }
        format.json { render json: @vat_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vat_rates/1
  # PATCH/PUT /vat_rates/1.json
  def update
    respond_to do |format|
      if @vat_rate.update(vat_rate_params)
        format.html { redirect_to @vat_rate, notice: 'Vat rate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vat_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vat_rates/1
  # DELETE /vat_rates/1.json
  def destroy
    @vat_rate.destroy
    respond_to do |format|
      format.html { redirect_to vat_rates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vat_rate
      @vat_rate = VatRate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vat_rate_params
      params[:vat_rate].permit(:symbol, :rate)
    end
end
