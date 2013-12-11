class SaleItem < ActiveRecord::Base
  belongs_to :sale_receipt
  belongs_to :sale
  delegate :sale, :to => :sale_receipt, :allow_nil => true
  attr_accessor :line
  
  before_save :read_from_line, :find_product
  
  def line
    self.sale_receipt.sale.file_content.lines[self.line_number]
  end
  
  private
  
  def find_product
    product = Product.sellable.detect{|p| p.name.downcase.gsub(/\s+/, "") == self.product_name.downcase.gsub(/\s+/, "")}
    if product
      self.product_id = product.id
    else
      product = ProductAlias.all.detect{|p| p.alias.downcase.gsub(/\s+/, "") == self.product_name.downcase.gsub(/\s+/, "")}
      if product
        self.product_id = product.product_id
      end
    end
  end
  
  def read_from_line
    # Get value and vat_symbol...
    regExp = /\d+.\d+[A-Z]/
    string = self.line.match(regExp)[0]
    self.vat_symbol = string.match(/[A-Z]/)[0]
    self.value = string.match(/\d+.\d+/)
    
    # ...and strip the line for further eveluation
    stripped_line = self.line.gsub!(regExp, '')
    
    # Get quantity and price...
    regExp = /\d*\.?\d*\*\d*\.?\d*/
    values = self.line.match(regExp)[0].split('*')
    self.quantity = values[0]
    self.price = values[1]
    
    # ...end strip...
    stripped_line = stripped_line.gsub!(regExp, '')

    # Remaining part is prouct_name
    self.product_name = stripped_line.gsub!(/[^0-9A-Za-z\s]/, '')
    
    if vat_rate
      self.net_value = self.value / (1 + self.vat_rate)
    end
  end
end
