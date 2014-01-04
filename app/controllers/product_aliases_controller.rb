class ProductAliasesController < ApplicationController
  before_action :set_product_alias, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end

  # GET /product_aliases
  def index
    @product_aliases = ProductAlias.all
    conditions = current_ability.model_adapter(ProductAlias, :read).conditions
    @product_aliases_grid = initialize_grid(ProductAlias, per_page: records_per_page, conditions: conditions, name: 'product_aliases_grid')
  end

  # GET /product_aliases/1
  def show
  end

  # GET /product_aliases/new
  def new
    @product_alias = ProductAlias.new
    @product_alias.attributes = { product_id: params[:product_id], :alias => params[:alias] }
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # GET /product_aliases/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # POST /product_aliases
  def create
    @product_alias = ProductAlias.new(product_alias_params)
    
    respond_to do |format|
      if @product_alias.save
        success = t("messages.saved.#{self.gender}", default: 'ProductAlias was sucessfully saved.', model: ProductAlias.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "new" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # PATCH/PUT /product_aliases/1
  def update
    respond_to do |format|
      if @product_alias.update(product_alias_params)
        success = t("messages.saved.#{self.gender}", default: 'ProductAlias was sucessfully saved.', model: ProductAlias.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # DELETE /product_aliases/1
  def destroy
    @product_alias.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'ProductAlias was sucessfully deleted.'], model: ProductAlias.model_name.human)
  end
  
  # PATCH /product_aliases/batch_destroy
  def batch_destroy
    ids = params[:product_aliases_grid][:selected]
    ProductAlias.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_alias
      @product_alias = ProductAlias.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_alias_params
      params.require(:product_alias).permit(:product_id, :alias)
    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
