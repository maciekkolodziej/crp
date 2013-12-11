
class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'female' 
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
    #render file: 'sales/file', layout: false
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
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # POST /sales
  def create
    @sale = Sale.new(sale_params)
    
    respond_to do |format|
      if @sale.save
        success = t("messages.saved.#{self.gender}", default: 'Sale was sucessfully saved.', model: Sale.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { flash[:alert] = @sale.errors.full_messages_for(:file_fingerprint); render action: "new" }
        format.js { render('shared/form_with_errors') }
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
      params.require(:sale).permit(:store_id, :date, :number, :value, :vat, :receipts_count, :cancelled_receipts_count, :cancelled_receipts_value, :file, :report_line)
    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
