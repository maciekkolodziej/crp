
class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def self.batch_actions
    [['Delete', :batch_destroy]]
  end

  def gender
    'female' 
  end

  # GET /roles
  def index
    @roles = Role.all
    @roles_grid = initialize_grid(Role, per_page: records_per_page, conditions: current_ability.model_adapter(Role, :read).conditions, name: 'roles_grid')
  end

  # GET /roles/1
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # POST /roles
  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to @role, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Role was sucessfully saved.'], model: Role.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update(role_params)
      redirect_to @role, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'Role was sucessfully saved.'], model: Role.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'Role was sucessfully deleted.'], model: Role.model_name.human)
  end
  
  # PATCH /roles/batch_destroy
  def batch_destroy
    ids = params[:roles_grid][:selected]
    Role.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :global)
    end
end
