class SaleReceiptsController < ApplicationController
  before_action :set_sale_receipt, only: [:show, :edit, :update, :destroy]

  # GET /sale_receipts
  # GET /sale_receipts.json
  def index
    @sale_receipts = SaleReceipt.all
  end

  # GET /sale_receipts/1
  # GET /sale_receipts/1.json
  def show
  end

  # GET /sale_receipts/new
  def new
    @sale_receipt = SaleReceipt.new
  end

  # GET /sale_receipts/1/edit
  def edit
  end

  # POST /sale_receipts
  # POST /sale_receipts.json
  def create
    @sale_receipt = SaleReceipt.new(sale_receipt_params)

    respond_to do |format|
      if @sale_receipt.save
        format.html { redirect_to @sale_receipt, notice: 'Sale receipt was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sale_receipt }
      else
        format.html { render action: 'new' }
        format.json { render json: @sale_receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale_receipts/1
  # PATCH/PUT /sale_receipts/1.json
  def update
    respond_to do |format|
      if @sale_receipt.update(sale_receipt_params)
        format.html { redirect_to @sale_receipt, notice: 'Sale receipt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sale_receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_receipts/1
  # DELETE /sale_receipts/1.json
  def destroy
    @sale_receipt.destroy
    respond_to do |format|
      format.html { redirect_to sale_receipts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_receipt
      @sale_receipt = SaleReceipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_receipt_params
      params.require(:sale_receipt).permit(:sale_id, :number, :value, :item_count, :cancelled, :salesman_id)
    end
end
