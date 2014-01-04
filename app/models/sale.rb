class Sale < ActiveRecord::Base
  stampable
  
  # Relations
  belongs_to :store
  has_many :sale_receipts, dependent: :destroy
  has_many :sale_items, through: :sale_receipts
  
  # File handling
  has_attached_file :file, path: ':rails_root/data/sales/:fingerprint.txt'
  attr_accessor :files
  
  # Validators
  validates_attachment :file, content_type: { content_type: "text/plain", message: :wrong_content_type }
  validates :file_fingerprint, uniqueness: true
  validate :file_contains_daily_report?, if: 'errors.blank?'
  
  # Callbacks
  before_save :read_attributes_from_file, :rewind
  after_save :create_receipts
  
  def items_by_product(options={})
    options[:agregate]        ||= 'SUM'
    options[:value]           ||= 'value'
    records = self.sale_items
                  .select("products.name AS product_name, SUM(sale_items.quantity) AS quantity, #{options[:agregate].to_s}(sale_items.#{options[:value].to_s}) AS value")
                  .joins(:sale_receipt)
                  .joins('LEFT OUTER JOIN products ON products.id = sale_items.product_id')
                  .group('product_name')
                  .order('value DESC')
                  
   if options[:for_chart]
     @chart_data = records.first(13).map{ |r| [r.product_name, r.value] }
   else
     records
   end
  end
  
  def items_by_category(options={})
    options[:agregate]        ||= 'SUM'
    options[:value]           ||= 'value'
    records = self.sale_items
                  .select("product_categories.name AS category, SUM(sale_items.quantity) AS quantity, #{options[:agregate].to_s}(sale_items.#{options[:value].to_s}) AS value")
                  .joins(:sale_receipt)
                  .joins('LEFT OUTER JOIN products ON products.id = sale_items.product_id')
                  .joins('LEFT OUTER JOIN product_categories ON product_categories.id = products.category_id')
                  .group('product_categories.name')
                  .order('value DESC')
                  
   if options[:for_chart]
     @chart_data = records.first(13).map{ |r| [r.category, r.value] }
   else
     records
   end
  end
  
  def by_hour(options={})
    options[:agregate]        ||= 'SUM'
    options[:value]           ||= 'value'
    records = self.sale_receipts
                  .select("HOUR(datetime) AS hour, COUNT(sale_receipts.id) AS quantity, (#{options[:agregate].to_s}(sale_receipts.#{options[:value].to_s}) / COUNT(DISTINCT DATE(datetime))) AS value")
                  .group('hour')
                  .order('hour')
                  
   if options[:for_chart]
     @chart_data = records.first(13).map{ |r| [r.hour, r.value] }
   else
     records
   end
  end
  
  # Provides unix timestamp for groupdate gem
  def datetime_timestamp
    return Date.parse(self.date).to_time
  end
  
  # Finds last sale date for given stores or store
  def self.last_date(options = {})
    options[:stores]          ||= Store.all
    sales = self.where(store_id: options[:stores].map{|s| s.id}).order('date DESC')
    sales.any? ? sales.first.date : nil
  end
  
  # Returns string with daily report read from file
  def daily_report
    report = self.file_content.lines[self.report_line..-1]
    last_line = report.find_index{|l| l.match(/‡CRC/) }
    report[0..last_line].join
  end
  
  # Reads file content from cache || queue || stored file
  attr_accessor :file_cache
  def file_content
    if self.file_cache.blank?
      if file.queued_for_write[:original].present?
        self.file_cache = read_from_queue
      else
        self.file_cache = read_from_storage
      end
    end
    file_cache
  end
  
  # Calculates net value
  def net_value
    if value && vat
      return value - vat
    else
      return ""
    end
  end
  
  # Creates receipts from file_content
  def create_receipts
    @lines.each_with_index do |line, i|
      # Create new Rceipt
      if line.include?('.      « P A R A G O N   F I S K A L N Y «       ')
        begins_at_line = i - header_length
        @receipt = SaleReceipt.new(sale_id: self.id, begins_at_line: begins_at_line)
        next
      end
      
      # If there are 2 empty lines tell receipt to read itself 
      # and search for another receipt
      if @receipt && line.strip.empty? && @lines[i+1].strip.empty?
        @receipt.ends_at_line = i-1
        @receipt.save
        @receipt = nil
        next
      end
    end
  end
  
  private
  
  # Validates if file is closed by daily report
  def file_contains_daily_report?
    if self.file_content.include?('.  R A P O R T   F I S K A L N Y   D O B O W Y   ')
      return true
    else
      errors.add(:file, :contains_no_daily_report)
      return false
    end
  end
  
  def read_attributes_from_file   
    # Converts file_content to array of lines
    @lines = self.file_content.lines
    
    # Reads report date from line no 10
    self.date = @lines[9][33..42].split('-').reverse.join('-')
    
    # Reads report number from line no 11
    self.number = @lines[10].match(/\d+/)[0]
    
    # Find store
    Store.all.each do |store|
      if store.register_header.present?
        if @lines.detect{|n| n.chomp.gsub(/\s+/, "") == store.register_header.chomp.gsub(/\s+/, "")}
          self.store_id = store.id
          break
        end
      end
    end
    
    # Finds position of daily fiscal report header
    self.report_line = @lines.find_index do |string|
      string.chop == '.  R A P O R T   F I S K A L N Y   D O B O W Y   '
    end
    
    # Finds vat value
    self.vat = @lines[self.report_line + 18].match('\d+\.?\d*')[0]
    
    # Finds total value
    self.value = @lines[self.report_line + 20].match('\d+\.?\d*')[0]
    
    # Find receipt_count
    self.receipts_count = @lines[self.report_line + 21].match(/\d+/)[0]
    
    # Find cancelled_receipt_count
    if line = @lines[self.report_line + 31].match(/\d+/)
      self.cancelled_receipts_count = line[0]
    else
      self.cancelled_receipts_count = 0
    end
    
    # Find cancelled_receipt_value
    if line = @lines[self.report_line + 30].match(/\d+.\d+/)
      self.cancelled_receipts_value = line[0]
    else
      self.cancelled_receipts_value = 0
    end
    return true
  end
  
  def header_length
    @lines[report_line-10..report_line].reverse.index{|n| n.chomp.gsub(/\s+/, "").empty? } - 1
  end
  
  # Create and send sale report
  def create_sale_report
    mail = LogMailer.sale_report(self).deliver
  end
  
  def read_from_queue
    file.queued_for_write[:original].read.force_encoding('Windows-1250').encode('UTF-8')
  end
  
  def read_from_storage
    File.open(file.path).read.force_encoding('Windows-1250').encode('UTF-8')
  end

  def rewind
    if file.queued_for_write[:original].present?
      file.queued_for_write[:original].rewind
    end
  end
  
end