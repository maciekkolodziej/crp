
class SaleReceiptsController < ApplicationController
  before_action :set_sale_receipt, only: [:show, :edit, :update, :destroy]

  # GET /sale_receipts
  def index
    @sale_receipts = SaleReceipt.all
    
    # Actions that are allowed to be executed in batch
    @batch_actions = { batch_destroy: "Delete" }
    @sale_receipts_grid = initialize_grid(SaleReceipt, per_page: records_per_page)
  end

  # GET /sale_receipts/1
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
  def create
    @sale_receipt = SaleReceipt.new(sale_receipt_params)

    if @sale_receipt.save
      redirect_to @sale_receipt, notice: 'Sale receipt was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /sale_receipts/1
  def update
    if @sale_receipt.update(sale_receipt_params)
      redirect_to @sale_receipt, notice: 'Sale receipt was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /sale_receipts/1
  def destroy
    @sale_receipt.destroy
    redirect_to sale_receipts_url, notice: 'Sale receipt was successfully destroyed.'
  end
  
  # PATCH /sale_receipts/batch_destroy
  def batch_destroy
    ids = params[:grid][:selected]
    SaleReceipt.destroy_all(id: ids)
    redirect_to request.referer, notice: "#{ids.count} records were successfully removed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_receipt
      @sale_receipt = SaleReceipt.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sale_receipt_params

      params.require(:sale_receipt).permit(:id, :sale_id, :number, :datetime, :value, :net_value, :cancelled, :salesman_id)

    end
end
