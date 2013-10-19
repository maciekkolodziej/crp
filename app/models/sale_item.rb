class SaleItem < ActiveRecord::Base
  belongs_to :sale_receipt
  attr_accessor :line
  
  before_save :read_from_line
  
  private
  
  def read_from_line
    # Get value and vat_symbol...
    regExp = /\d+.\d+[A-Z]/
    string = self.line.match(regExp)[0]
    self.vat_symbol = string.match(/[A-Z]/)[0]
    self.value = string.match(/\d+.\d+/)
    
    # ...and strip the line for further eveluation
    self.line = self.line.gsub(regExp, '')
    
    # Get quantity and price...
    regExp = /\d+.\d+\*\d+.\d+/
    values = self.line.match(regExp)[0].split('*')
    self.quantity = values[0]
    self.price = values[1]
    
    # ...end strip...
    self.line = self.line.gsub(regExp, '')
    
    # Remaining part is prouct_name
    self.product_name = line.gsub(/[^0-9A-Za-z\s]/, '')
  end
end