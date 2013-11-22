class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: [:show, :edit, :update, :destroy]

  def gender
    'female' 
  end
  
  def import
    ProductCategory.destroy_all
    CrpProductCategory.all.each do |old|
      ProductCategory.new(id: old.id, symbol: old.symbol, name: old.name).save
    end
    redirect_to product_categories_path, notice: "#{CrpProductCategory.count} records imported."
  end

  # GET /product_categories
  def index
    @product_categories = ProductCategory.all
    
    # Actions that are allowed to be executed in batch
    @batch_actions = { batch_destroy: t('delete', default: 'Delete').capitalize }
    @product_categories_grid = initialize_grid(ProductCategory, per_page: records_per_page, conditions: current_ability.model_adapter(ProductCategory, :read).conditions, order: 'symbol')
  end

  # GET /product_categories/1
  def show
  end

  # GET /product_categories/new
  def new
    @product_category = ProductCategory.new
  end

  # GET /product_categories/1/edit
  def edit
  end

  # POST /product_categories
  def create
    @product_category = ProductCategory.new(product_category_params)

    if @product_category.save
      redirect_to @product_category, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'ProductCategory was sucessfully saved.'], model: ProductCategory.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /product_categories/1
  def update
    if @product_category.update(product_category_params)
      redirect_to @product_category, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'ProductCategory was sucessfully saved.'], model: ProductCategory.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /product_categories/1
  def destroy
    @product_category.destroy
    redirect_to product_categories_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'ProductCategory was sucessfully deleted.'], model: ProductCategory.model_name.human)
  end
  
  # PATCH /product_categories/batch_destroy
  def batch_destroy
    ids = params[:grid][:selected]
    ProductCategory.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed.many', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_category_params
      params.require(:product_category).permit(:symbol, :name)
    end
end
