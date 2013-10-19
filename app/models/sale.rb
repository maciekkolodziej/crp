class Sale < ActiveRecord::Base
  # Relations
  has_many :sale_receipts, dependent: :destroy
  
  # Additional attributes
  attr_accessor :file
  
  # Validators
  validates :card_payments, :numericality => true, :presence => true
  validates :file, :presence => true
  
  # Callbacks
  before_save :set_file_content, :read_attributes_from_file
  after_save :create_receipts
  
  def cash_payments
    return self.value - self.card_payments.to_f
  end
  
  def net_value
    if self.value && self.vat
      return self.value - self.vat
    else
      return ""
    end
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
      self.cancelled_receipt_count = @lines[summary_line_no + 31].match(/\d+/)[0]
      
      # Find cancelled_receipt_value
      self.cancelled_receipt_value = @lines[summary_line_no + 30].match(/\d+.\d+/)[0]
      
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
  
end
