class SaleReceipt < ActiveRecord::Base
  # Relations
  belongs_to :sale
  has_many :sale_items, dependent: :destroy
  
  # Callbacks
  before_save :read_from_file
  after_save :create_items
  
  # Validations
  validates :salesman_id, length: { maximum: 3 }
  
  # Converts file_content for this receipt into array of lines
  def lines
    return self.sale.file_content.lines[self.begins_at_line..self.ends_at_line]
  end
  
  # Makes file content out of lines array
  def file_content
    return self.lines.join
  end
  
  # Count of lines
  def line_count
    return self.ends_at_line - self.begins_at_line
  end
  
  # Count of items
  def item_count
    return self.sale_items.count
  end
  
  private
  
  def create_items
    if @item_lines
      @item_lines.each do |line|
        # Get vat_symbol from line
        vat_symbol = line[1].strip[-1..-1]
        # Get vat_rate for that symbol if @vat_rates are not empty (like in cancelled receipt)
        if @vat_rates
          vat_rate = @vat_rates[vat_symbol]
        end
        # Create item - pass line number, line and vat rate
        self.sale_items.create(line_number: line[0], line: line[1], vat_rate: vat_rate)
      end
    end
  end
  
  def read_from_file
    self.lines.each_with_index do |line, i|
      
      # Get date
      if date = line.match('\d{2}-\d{2}-\d{4}')
        @date = date[0].split('-').reverse.join('-')
        next
      end
      
      # Get time
      if time = line.match('\d{2}:\d{2}')
        self.datetime = @date + ' ' + time[0]
      end
      
      # Get number
      if number = line[1..6].match('F\d{5}')
        self.number = number[0][1..6]
        next
      end
      
      # Get total value
      if line.include?('S U M A :')
        self.value = line.gsub(/[^[0-9.]]/, "")[1..-1]
        self.net_value = self.value - self.lines[i-2].gsub(/[^[0-9.]]/, "").to_f
        next
      end
      
      # Check if cancelled
      if line.include?('PARAGON ANULOWANY')
        self.cancelled = true
        next
      end
      
      # Store VAT rates for creating item
      if line.match(/[A-D]:.*\d+.\d+\%/)
        @vat_rates ||= {}
        # Like A:
        symbol = line.match(/[A-D]:/)[0][0..0]
        # Match % and convert to rate
        rate = line.match(/\d+.\d+\%/)[0].to_f / 100
        # Add to @vat_rates hash
        @vat_rates[symbol] = rate
        logger.debug "Rate: #{rate} \ Symbol: #{symbol}"
        logger.debug @vat_rates.inspect
        next
      end
      
      # Check if it's recipe item
      if line.match('\d+\*\d+.\d+')
        @item_lines ||= []
        @item_lines << [self.begins_at_line + i, line]
      end
      
    end
  end
end
      
      
