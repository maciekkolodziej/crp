class ProductTypesController < ApplicationController
  before_action :set_product_type, only: [:show, :edit, :update, :destroy]

  def gender
    'male' 
  end
  
  def import
    ProductType.destroy_all
    CrpProductType.all.each do |old|
      ProductType.new(id: old.id, name: old.name, description: old.description).save
    end
    redirect_to request.referer, notice: "#{CrpProductType.count} records imported."
  end

  # GET /product_types
  def index
    @product_types = ProductType.all
    
    # Actions that are allowed to be executed in batch
    @batch_actions = { batch_destroy: t('delete', default: 'Delete').capitalize }
    @product_types_grid = initialize_grid(ProductType, per_page: records_per_page, conditions: current_ability.model_adapter(ProductType, :read).conditions)
  end

  # GET /product_types/1
  def show
  end

  # GET /product_types/new
  def new
    @product_type = ProductType.new
  end

  # GET /product_types/1/edit
  def edit
  end

  # POST /product_types
  def create
    @product_type = ProductType.new(product_type_params)

    if @product_type.save
      redirect_to @product_type, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'ProductType was sucessfully saved.'], model: ProductType.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /product_types/1
  def update
    if @product_type.update(product_type_params)
      redirect_to @product_type, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'ProductType was sucessfully saved.'], model: ProductType.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /product_types/1
  def destroy
    @product_type.destroy
    redirect_to product_types_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'ProductType was sucessfully deleted.'], model: ProductType.model_name.human)
  end
  
  # PATCH /product_types/batch_destroy
  def batch_destroy
    ids = params[:grid][:selected]
    ProductType.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed.many', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_type
      @product_type = ProductType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_type_params
      params.require(:product_type).permit(:name, :description)
    end
end
