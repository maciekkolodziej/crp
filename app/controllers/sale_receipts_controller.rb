class SaleReceiptsController < ApplicationController
  before_action :set_sale_receipt, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end

  # GET /sale_receipts
  def index
    @sale_receipts = SaleReceipt.all
    
    conditions = current_ability.model_adapter(SaleReceipt, :read).conditions
    conditions['sales.store_id'] = current_user.current_store_id
    @sale_receipts_grid = initialize_grid(SaleReceipt, per_page: records_per_page, include: [:sale], conditions: conditions, name: 'sale_receipts_grid', order: 'datetime', order_direction: 'DESC')
  end

  # GET /sale_receipts/1
  def show
    @sale_items_grid = initialize_grid(SaleItem, per_page: records_per_page, conditions: { 'sale_items.sale_receipt_id' => @sale_receipt.id }, name: 'items_grid')
  end

  # GET /sale_receipts/new
  def new
    @sale_receipt = SaleReceipt.new
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # GET /sales/1/edit
  def edit
    redirect_to request.referer ? request.referer : root_path
  end

  # POST /sale_receipts
  def create
    @sale_receipt = SaleReceipt.new(sale_receipt_params)
    
    respond_to do |format|
      if @sale_receipt.save
        success = t("messages.saved.#{self.gender}", default: 'SaleReceipt was sucessfully saved.', model: SaleReceipt.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "new" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # PATCH/PUT /sale_receipts/1
  def update
    respond_to do |format|
      if @sale_receipt.update(sale_receipt_params)
        success = t("messages.saved.#{self.gender}", default: 'SaleReceipt was sucessfully saved.', model: SaleReceipt.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # DELETE /sale_receipts/1
  def destroy
    @sale_receipt.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'SaleReceipt was sucessfully deleted.'], model: SaleReceipt.model_name.human)
  end
  
  # PATCH /sale_receipts/batch_destroy
  def batch_destroy
    ids = params[:sale_receipts_grid][:selected]
    SaleReceipt.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_receipt
      @sale_receipt = SaleReceipt.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sale_receipt_params

      params.require(:sale_receipt).permit(:sale_id, :number, :datetime, :value, :net_value, :cancelled)

    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
