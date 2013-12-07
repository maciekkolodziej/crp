class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end

  # GET /stores
  def index
    @stores = Store.all
    @stores_grid = initialize_grid(Store, per_page: records_per_page, conditions: current_ability.model_adapter(Store, :read).conditions, name: 'stores_grid')
  end

  # GET /stores/1
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  def create
    @store = Store.new(store_params)

    if @store.save
      redirect_to @store, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Store was sucessfully saved.'], model: Store.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /stores/1
  def update
    if @store.update(store_params)
      redirect_to @store, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Store was sucessfully saved.'], model: Store.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /stores/1
  def destroy
    @store.destroy
    redirect_to stores_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'Store was sucessfully deleted.'], model: Store.model_name.human)
  end
  
  # PATCH /stores/batch_destroy
  def batch_destroy
    ids = params[:stores_grid][:selected]
    Store.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def store_params

      params.require(:store).permit(:symbol, :name, employees_attributes: [:id, :user_id, :role_id, :_destroy])

    end
end
