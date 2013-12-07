<% if namespaced? -%>require_dependency "<%= namespaced_file_path %>/application_controller"<% end -%><% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end

  # GET <%= route_url %>
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
    
    conditions = current_ability.model_adapter(<%= class_name -%>, :read).conditions
    @<%= plural_table_name %>_grid = initialize_grid(<%= class_name -%>, per_page: records_per_page, conditions: conditions, name: '<%= plural_table_name %>_grid')
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js { render('shared/build_modal') }
    end
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    
    respond_to do |format|
      if @<%= orm_instance.save %>
        success = t("messages.saved.#{self.gender}", default: '<%= class_name %> was sucessfully saved.', model: <%= class_name %>.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "new" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        success = t("messages.saved.#{self.gender}", default: '<%= class_name %> was sucessfully saved.', model: <%= class_name %>.model_name.human)
        format.html { redirect_to params[:referer], notice: success }
        format.js { flash[:notice] = success; render js: "close_modal(); redirect('#{params[:referer]}')" }
      else
        format.html { render action: "edit" }
        format.js { render('shared/form_with_errors') }
      end
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', '<%= class_name %> was sucessfully deleted.'], model: <%= class_name %>.model_name.human)
  end
  
  # PATCH <%= route_url %>/batch_destroy
  def batch_destroy
    ids = params[:<%= plural_table_name %>_grid][:selected]
    <%= class_name -%>.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
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
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
<% end -%>