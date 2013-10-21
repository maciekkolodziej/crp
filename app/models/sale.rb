class Sale < ActiveRecord::Base
  # Relations
  belongs_to :pos
  has_many :sale_receipts, dependent: :destroy
  has_many :sale_items, through: :sale_receipts
  
  # Additional attributes
  attr_accessor :file
  
  # Validators
  validates :card_payments, numericality: true, presence: true
  validates :file, presence: true
  validate :file_contains_daily_report?
  
  # Callbacks
  before_validation :set_file_content
  before_save :read_attributes_from_file
  after_save :create_receipts, :create_sale_report
  
  # Provides unix timestamp for groupdate gem
  def datetime_timestamp
    return Date.parse(self.date).to_time
  end
  
  # Calculates net value
  def net_value
    if self.value && self.vat
      return self.value - self.vat
    else
      return ""
    end
  end
  
  # Calculates cash payments
  def cash_payments
    return self.value - self.card_payments.to_f
  end
  
  # Sets file_content attribute if file was supplied
  def set_file_content
    if file
      self.file_content = file.read.encode("UTF-8", invalid: :replace, undef: :replace)
    else
      self.file_content = nil
    end
  end
  
  private
  
  # Validates if file is closed by daily report
  def file_contains_daily_report?
    if self.file_content.include?('.  R A P O R T   F I S K A L N Y   D O B O W Y   ')
      return true
    else
      errors.add(:file, "Couldn't find daily fiscal report.")
      return false
    end
  end
  
  def read_attributes_from_file
    if self.file_content
      # Converts file_content to array of lines
      @lines = self.file_content.lines
      
      # Reads report date from line no 10
      self.date = @lines[9][33..42].split('-').reverse.join('-')
      
      # Reads report number from line no 11
      self.number = @lines[10].match('\d+')[0]
      
      # TODO: Finds pos_id by unique register number
      register_number = @lines[6].chop[-11..-1]
      #self.pos_id = Pos.find_by_register_number(register_number).id
      
      # Finds position of daily fiscal report header
      summary_line_no = @lines.index do |string|
        string.chop == '.  R A P O R T   F I S K A L N Y   D O B O W Y   '
      end
      
      # Finds vat value
      self.vat = @lines[summary_line_no + 18].match('\d+\.?\d*')[0]
      
      # Finds total value
      self.value = @lines[summary_line_no + 20].match('\d+\.?\d*')[0]
      
      # Find receipt_count
      self.receipt_count = @lines[summary_line_no + 21].match(/\d+/)[0]
      
      # Find cancelled_receipt_count
      if line = @lines[summary_line_no + 31].match(/\d+/)
        self.cancelled_receipt_count = line[0]
      else
        self.cancelled_receipt_count = 0
      end
      
      # Find cancelled_receipt_value
      if line = @lines[summary_line_no + 30].match(/\d+.\d+/)
        self.cancelled_receipt_value = line[0]
      else
        self.cancelled_receipt_value = 0
      end
      return true
    else
      return false
    end
  end
  
  # Creates receipts from file_content
  def create_receipts
    @lines.each_with_index do |line, i|
      
      # Create new Rceipt
      if line.include?('P A R A G O N   F I S K A L N Y')
        @receipt = SaleReceipt.new(sale_id: self.id, begins_at_line: i-6)
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
  
end
