class Sale < ActiveRecord::Base
  stampable
  has_paper_trail
  
  # Relations
  belongs_to :store
  has_many :sale_receipts, dependent: :destroy
  has_many :sale_items, through: :sale_receipts
  
  # File handling
  has_attached_file :file, path: ':rails_root/data/sales/:fingerprint.txt'
  
  # Validators
  validates_attachment :file, content_type: { content_type: "text/plain" }, presence: true
  validates :file_fingerprint, uniqueness: true
  validate :file_contains_daily_report?, if: 'errors.blank?'
  
  # Callbacks
  before_save :read_attributes_from_file, :rewind
  after_save :create_receipts #, :create_sale_report
  
  # Provides unix timestamp for groupdate gem
  def datetime_timestamp
    return Date.parse(self.date).to_time
  end
  
  def daily_report
    report = self.file_content.lines[self.report_line..-1]
    last_line = report.find_index{|l| l.match(/‡CRC/) }
    logger.error last_line
    report[0..last_line].join
  end
  
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
  
  private
  
  # Validates if file is closed by daily report
  def file_contains_daily_report?
    if self.file_content.include?('.  R A P O R T   F I S K A L N Y   D O B O W Y   ')
      return true
    else
      errors.add(:file, 'No daily report')
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