<% if namespaced? -%>require_dependency "<%= namespaced_file_path %>/application_controller"<% end -%><% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def gender
    'male' 
  end

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
    
    # Actions that are allowed to be executed in batch
    @batch_actions = { batch_destroy: t('delete', default: 'Delete').capitalize }
    @<%= plural_table_name %>_grid = initialize_grid(<%= class_name -%>, per_page: records_per_page, conditions: current_ability.model_adapter(<%= class_name -%>, :read).conditions)
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', '<%= class_name %> was sucessfully saved.'], model: <%= class_name %>.model_name.human)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to @<%= singular_table_name %>, notice: t("messages.saved.#{self.gender}", default: [:'messages.saved', '<%= class_name %> was sucessfully saved.'], model: <%= class_name %>.model_name.human)
    else
      render action: 'edit'
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', '<%= class_name %> was sucessfully deleted.'], model: <%= class_name %>.model_name.human)
  end
  
  # PATCH <%= route_url %>/batch_destroy
  def batch_destroy
    ids = params[:grid][:selected]
    <%= class_name -%>.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed.many', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>