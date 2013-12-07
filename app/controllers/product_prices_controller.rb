class ProductPricesController < ApplicationController
  before_action :set_product_price, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'female' 
  end
  
  def import
    ProductPrice.destroy_all
    CrpPosProduct.all.each do |old|
      if Product.exists?(id: old.product_id.to_i) && CrpProduct.find(old.product_id).sellable == true && Store.exists?(id: old.pos_id.to_i)
        ProductPrice.new(id: old.id, 
                    store_id: old.pos_id,
                    product_id: old.product_id,
                    sale_price: old.sale_price.blank? ? old.crp_product.sale_price : old.sale_price
                   ).save(validate: false)
      end
    end
    redirect_to product_prices_path, notice: "#{ProductPrice.count} records imported."
  end

  # GET /product_prices
  def index
    @product_prices = ProductPrice.all
    @conditions = current_ability.model_adapter(ProductPrice, :read).conditions
    @conditions.is_a?(String) ? @conditions = { store_id: current_user.current_store_id } : @conditions[:store_id] = current_user.current_store_id
    @product_prices_grid = initialize_grid(ProductPrice, include: [:product], per_page: records_per_page, conditions: @conditions, include: [:product], order: 'products.register_code', name: 'product_prices_grid')

  end

  # GET /product_prices/1
  def show
  end

  # GET /product_prices/new
  def new
    if params[:product_id] && Product.find(params[:product_id]).sellable == false
      flash[:alert] = t('Product not sellable', default: 'This product is not for sale.')
      respond_to do |format|
        format.html { redirect params[:referer] }
        format.js { render js: "close_modal(); redirect('#{params[:referer]}')" }
      end
    else
      @product_price = ProductPrice.new
      @product_price.attributes = { store_id: params[:store_id], product_id: params[:product_id] }
      
      respond_to do |format|
        format.html
        format.js { render('shared/build_modal') }
      end
    end
  end

  # GET /product_prices/1/edit
  def edit
    params[:store_id] = @product_price.store_id
    params[:product_id] = @product_price.product_id
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # POST /product_prices
  def create
    @product_price = ProductPrice.new(product_price_params)
    
    respond_to do |format|
      if @product_price.save
        success = t("messages.saved.#{self.gender}", default: [:'messages.saved', 'ProductPrice was sucessfully saved.'], model: ProductPrice.model_name.human)
        format.html { redirect_to @product_price, notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
        format.json { render json: @product_price, status: :created, location: @product_price }
      else
        format.html { render action: "new" }
        format.js { render('shared/form_with_errors') }
        format.json { render json: @product_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_prices/1
  def update
    respond_to do |format|
      if @product_price.update(product_price_params)
        success = t("messages.saved.#{self.gender}", default: [:'messages.saved', 'ProductPrice was sucessfully saved.'], model: ProductPrice.model_name.human)
        format.html { redirect_to @product_price, notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
        format.json { render json: @product_price, status: :created, location: @product_price }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
        format.json { render json: @product_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_prices/1
  def destroy
    @product_price.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'ProductPrice was sucessfully deleted.'], model: ProductPrice.model_name.human)
  end
  
  # PATCH /product_prices/batch_destroy
  def batch_destroy
    ids = params[:product_prices_grid][:selected]
    ProductPrice.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_price
      @product_price = ProductPrice.find(params[:id])
    end

    def set_referer
      params[:referer] ||= request.referer
    end

    # Only allow a trusted parameter "white list" through.
    def product_price_params
      params.require(:product_price).permit(:product_id, :store_id, :sale_price)
    end
end
