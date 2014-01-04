class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'female' 
  end
  
  def unrecognized_products
    @products = SaleItem::unrecognized_products(current_user.current_store_id)
  end

  # GET /sales
  def index
    @sales = Sale.all
    
    conditions = current_ability.model_adapter(Sale, :read).conditions
    conditions[:store_id] = current_user.current_store_id
    @sales_grid = initialize_grid(Sale, per_page: records_per_page, conditions: conditions, name: 'sales_grid')
  end

  # GET /sales/1
  def show
    @sale_receipts_grid = initialize_grid(SaleReceipt, per_page: records_per_page, conditions: { sale_id: @sale.id }, name: 'receipts_grid')
    @sale_items_grid = initialize_grid(SaleItem, per_page: records_per_page, include: [:sale_receipt], conditions: { 'sale_receipts.sale_id' => @sale.id }, name: 'items_grid')
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # GET /sales/1/edit
  def edit
    redirect_to request.referer ? request.referer : root_path
  end

  # POST /sales
  def create
    if params[:files].present?
      params[:files].each do |file|
        @sale = Sale.new(file: file)
        if @sale.valid?
          @sales_to_save ||= []
          @sales_to_save << @sale
        else
          flash.now[:error] ||= []
          @sale.errors.delete(:file)
          flash.now[:error] << @sale.errors.full_messages.to_sentence unless flash.now[:error].length >= 10
        end
      end
      
      if @sales_to_save
        flash[:notice] = t('Saved files', default: 'Saved files') + ': '
        file_names = []
        @sales_to_save.each do |sale|
          file_names << sale.file_file_name
          sale.save
        end
        flash[:notice] += file_names.join(', ')
        respond_to do |format|
          format.html { redirect_to params[:referer] }
        end
      else
        render 'new'
      end
    else
      flash.now[:error] = [t('activerecord.attributes.sale.file', default: 'File'), t('errors.messages.not_selected', default: 'was not selected.')].join(' ')
      respond_to do |format|
        format.html { render 'new' }
      end
    end
  end

  # PATCH/PUT /sales/1
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        success = t("messages.saved.#{self.gender}", default: 'Sale was sucessfully saved.', model: Sale.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # DELETE /sales/1
  def destroy
    @sale.destroy
    redirect_to sales_path, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'Sale was sucessfully deleted.'], model: Sale.model_name.human)
  end
  
  # PATCH /sales/batch_destroy
  def batch_destroy
    ids = params[:sales_grid][:selected]
    Sale.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sale_params
      params.require(:sale).permit(:store_id, :date, :number, :value, :vat, :receipts_count, :cancelled_receipts_count, :cancelled_receipts_value, :file, :report_line, :files)
    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
