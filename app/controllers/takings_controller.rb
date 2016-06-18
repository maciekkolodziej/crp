
class TakingsController < ApplicationController
  before_action :set_taking, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end

  # GET /takings
  def index
    @takings = Taking.all
    
    conditions = current_ability.model_adapter(Taking, :read).conditions
    conditions[:store_id] = current_user.current_store_id
    @takings_grid = initialize_grid(Taking, per_page: records_per_page, order: 'date', order_direction: 'DESC', conditions: conditions, name: 'takings_grid')
  end

  # GET /takings/1
  def show
  end

  # GET /takings/new
  def new
    @taking = Taking.new
    @taking.date = Date::current
    @taking.store_id = current_user.current_store_id
    
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # GET /takings/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # POST /takings
  def create
    @taking = Taking.new(taking_params)
    @taking.store_id = current_user.current_store_id unless current_user.has_global_role?
    
    respond_to do |format|
      if @taking.save
        success = t("messages.saved.#{self.gender}", default: 'Taking was sucessfully saved.', model: Taking.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "new" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # PATCH/PUT /takings/1
  def update
    respond_to do |format|
      if @taking.update(taking_params)
        success = t("messages.saved.#{self.gender}", default: 'Taking was sucessfully saved.', model: Taking.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # DELETE /takings/1
  def destroy
    @taking.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'Taking was sucessfully deleted.'], model: Taking.model_name.human)
  end
  
  # PATCH /takings/batch_destroy
  def batch_destroy
    ids = params[:takings_grid][:selected]
    Taking.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_taking
      @taking = Taking.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def taking_params

      params.require(:taking).permit(:store_id, :date, :value, :card_payments, :cash_payments)

    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
