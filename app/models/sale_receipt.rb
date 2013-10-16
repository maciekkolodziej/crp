class SaleReceipt < ActiveRecord::Base
  # Relations
  belongs_to :sale
  has_many :sale_items, dependent: :destroy
  
  # Callbacks
  before_save :read_from_file
  after_save :create_items
  
  def lines
    return self.sale.file_content.lines[self.begins_at_line..self.ends_at_line]
  end
  
  def file_content
    return self.lines.join
  end
  
  def line_count
    return self.ends_at_line - self.begins_at_line
  end
  
  private
  
  def create_items
    @item_lines.each do |line|
      self.sale_items.create(line_number: line[0], line: line[1])
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
      
      # Check if it's recipe item
      if line.match('\d+.\d+\*\d+.\d+')
        @item_lines ||= []
        @item_lines << [self.begins_at_line + i, line]
      end
      
    end
  end
end
      
      
