class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :show_version, :edit, :update, :destroy]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end

  def gender
    'male' 
  end

  # GET /products
  def index
    @products = Product.all
    @products_grid = initialize_grid(Product, per_page: records_per_page, conditions: current_ability.model_adapter(Product, :read).conditions, name: 'products_grid')
  end

  # GET /products/1
  def show
    @product_prices_grid = initialize_grid(ProductPrice, include: [:product], conditions: { product_id: @product.id}, name: "product_prices_grid")                                   
    @product_aliases_grid = initialize_grid(ProductAlias, include: [:product], conditions: { product_id: @product.id}, name: 'product_aliases_grid')
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Product was sucessfully saved.'], model: Product.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Product was sucessfully saved.'], model: Product.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'Product was sucessfully deleted.'], model: Product.model_name.human)
  end
  
  # PATCH /products/batch_destroy
  def batch_destroy
    ids = params[:products_grid][:selected]
    Product.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :unit_id, :active, :purchasable, :inventoried, :cost_price, :sellable, :register_code, :register_name, :category_id, :vat_rate_id)
    end
end
