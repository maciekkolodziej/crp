class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  
  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all
    @chart_data = Pos.all.map do |pos|
      sales_count = pos.sales.count
      @data = {}
      pos.sale_receipts.group_by_hour_of_day(:datetime).sum(:net_value).each {|key, value| @data[key] = (value / sales_count) * 0.62 - 10}
      {
        :name => pos.name, 
        :data => @data
      }
    end
    
    # Actions that are allowed to be executed in batch
    @batch_actions = { batch_destroy: "Delete", batch_approve: "Approve" }
    @sales_grid = initialize_grid(Sale, include: [:pos, :sale_receipts], order: 'date', order_direction: 'desc', per_page: records_per_page)
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sale }
      else
        format.html { render action: 'new' }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url }
      format.json { head :no_content }
    end
  end
  
  # PATCH /sales/batch_destroy
  def batch_destroy
    ids = params[:grid][:selected]
    Sale.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed.many', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end
  
  # PATCH /sales/batch_approve
  def batch_approve
    ids = params[:grid][:selected]
    Sale.where(id: ids).update_all(card_payments: 1000)
    redirect_to request.referer, notice: "#{ids.count} records successfully approved."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:card_payments, :file)
    end
end
