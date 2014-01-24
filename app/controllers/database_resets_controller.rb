class DatabaseResetsController < ApplicationController
  before_action :set_database_reset, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:index, :edit, :new]

  skip_before_filter :authenticate_user!, :only => [:do_reset]
  
  def self.batch_actions
    [['Delete', :batch_destroy]]
  end
  
  def gender
    'male' 
  end
  
  def self.reset_interval
    5.minutes
  end
  
  def self.reset_allowed?(request)
    # Not production AND either first reset OR interval > 5 minutes
    !Rails.env.production? && (DatabaseReset.where(ip: request.remote_ip).blank? || (Time.now.to_i - DatabaseReset.where(ip: request.remote_ip).order('created_at DESC').first.created_at.to_i >= DatabaseResetsController::reset_interval))
  end

  def do_reset
    redirect_path = user_signed_in? ? (request.referer || locale_root_path) : (request.referer || new_user_session_path)
    if self.class.reset_allowed?(request)
      flash[:notice] = t('Database reset', default: 'Database has been reset.')
      redirect_to redirect_path
      
      connection = ActiveRecord::Base.connection
      connection.execute('SET FOREIGN_KEY_CHECKS = 0')
      connection.tables.each do |table|
        connection.execute("TRUNCATE #{table}") unless table == "schema_migrations" || table == "database_resets"
      end
      # - IMPORTANT: SEED DATA ONLY
      # - DO NOT EXPORT TABLE STRUCTURES
      # - DO NOT EXPORT DATA FROM `schema_migrations`
      sql = File.read('data/demo/demo_db.sql')
      statements = sql.split(/;$/)
      statements.pop  # the last empty statement
     
      ActiveRecord::Base.transaction do
        statements.each do |statement|
          connection.execute(statement)
        end
      end
      connection.execute('SET FOREIGN_KEY_CHECKS = 1')
      
      # Remove all files from data/sales
      FileUtils.rm Dir.glob(Rails.root.join('data/sales/*'))
      
      # Restore sale report files from data/demo/sales
      FileUtils.cp Dir.glob(Rails.root.join('data/demo/sales/*')), Rails.root.join('data/sales')
      
      reset = DatabaseReset.new
      reset.update_attributes(ip: request.remote_ip, hostname: Resolv.new.getname(request.remote_ip))
    else
      if Rails.env.production?
        flash[:error] = t('Reset impossible', default: 'Production mode. Reset impossible')
      else
        flash[:error] = t("Too many resets", default: "Too many resets. Wait another %{seconds} seconds.", seconds: (self.class.reset_interval - (Time.now.to_i - DatabaseReset.where(ip: request.remote_ip).order('created_at DESC').first.created_at.to_i)))
      end
      redirect_to redirect_path
    end
  end

  # GET /database_resets
  def index
    @database_resets = DatabaseReset.all
    
    conditions = current_ability.model_adapter(DatabaseReset, :read).conditions
    @database_resets_grid = initialize_grid(DatabaseReset, per_page: records_per_page, conditions: conditions, name: 'database_resets_grid', order: 'created_at', order_direction: 'DESC')
  end

  # GET /database_resets/1
  def show
  end

  # DELETE /database_resets/1
  def destroy
    @database_reset.destroy
    redirect_to request.referer, notice: t("messages.destroyed.#{self.gender}", default: [:'messages.destroyed', 'DatabaseReset was sucessfully deleted.'], model: DatabaseReset.model_name.human)
  end
  
  # PATCH /database_resets/batch_destroy
  def batch_destroy
    ids = params[:database_resets_grid][:selected]
    DatabaseReset.destroy_all(id: ids)
    redirect_to request.referer, notice: t('messages.destroyed', default: "#{ids.count} records were successfully removed.", count: ids.count)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_database_reset
      @database_reset = DatabaseReset.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def database_reset_params

      params.require(:database_reset).permit(:ip, :hostname, :created_at, :updated_at)

    end
    
    def set_referer
      params[:referer] ||= request.referer
    end
end
