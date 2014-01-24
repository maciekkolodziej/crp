
class SaleItemsController < ApplicationController
  before_action :set_sale_item, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'female' 
  end

  # GET /sale_items
  def index
    @sale_items = SaleItem.all
    
    conditions = current_ability.model_adapter(SaleItem, :read).conditions
    conditions['sales.store_id'] = current_user.current_store_id
    @sale_items_grid = initialize_grid(SaleItem, per_page: records_per_page, joins: ['JOIN sale_receipts ON sale_receipts.id = sale_items.sale_receipt_id', 'JOIN sales ON sales.id = sale_receipts.sale_id'], conditions: conditions, name: 'sale_items_grid', order: 'sale_receipts.datetime', order_direction: 'DESC')
  end

  # GET /sale_items/1
  def show
  end

  # GET /sale_items/new
  def new
    @sale_item = SaleItem.new
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # GET /sales/1/edit
  def edit
    redirect_to request.referer ? request.referer : root_path
  end

  # POST /sale_items
  def create
    @sale_item = SaleItem.new(sale_item_params)
    
    respond_to do |format|
      if @sale_item.save
        success = t("messages.saved.#{self.gender}", default: 'SaleItem was sucessfully saved.', model: SaleItem.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "new" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # PATCH/PUT /sale_items/1
  def update
    respond_to do |format|
      if @sale_item.update(sale_item_params)
        success = t("messages.saved.#{self.gender}", default: 'SaleItem was sucessfully saved.', model: SaleItem.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # DELETE /sale_items/1
  def destroy
    @sale_item.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'SaleItem was sucessfully deleted.'], model: SaleItem.model_name.human)
  end
  
  # PATCH /sale_items/batch_destroy
  def batch_destroy
    ids = params[:sale_items_grid][:selected]
    SaleItem.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_item
      @sale_item = SaleItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sale_item_params

      params.require(:sale_item).permit(:sale_receipt_id, :product_id, :product_name, :quantity, :price, :value, :net_value, :vat_symbol, :vat_rate)

    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
