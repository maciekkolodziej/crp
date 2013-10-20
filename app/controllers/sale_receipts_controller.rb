class SaleReceiptsController < ApplicationController
  before_action :set_sale_receipt, only: [:show, :destroy]

  # GET /sale_receipts
  # GET /sale_receipts.json
  def index
    @sale_receipts = SaleReceipt.all
  end

  # GET /sale_receipts/1
  # GET /sale_receipts/1.json
  def show
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
    
end
