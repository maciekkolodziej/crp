class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end
  
  def new
    redirect_to request.referer ? request.referer : root_path
  end

  # GET /users
  def index
    @users = User.all
    @users_grid = initialize_grid(User, per_page: records_per_page, conditions: current_ability.model_adapter(User, :read).conditions, name: 'users_grid')
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end
  
  # GET /users/change_store/1
  def change_store
    store_id = params[:store_id]
    if(current_user.can_use_store?(store_id))
      current_user.update(current_store_id: store_id)
      redirect_to request.referer, notice: t('Store changed', default: 'Store was sucessfully changed. Current store is <strong>%{current_store}</strong>.', current_store: Store.find(store_id).name)
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', 'User was sucessfully saved.'], model: User.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'User was sucessfully deleted.'], model: User.model_name.human)
  end
  
  # PATCH /users/batch_destroy
  def batch_destroy
    ids = params[:users_grid][:selected]
    User.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :current_store_id, :active, roles_attributes: [:id, :role_id, :store_id, :_destroy])
    end
end
