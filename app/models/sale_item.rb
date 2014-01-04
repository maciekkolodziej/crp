class SaleItem < ActiveRecord::Base
  belongs_to :sale_receipt
  belongs_to :sale
  belongs_to :product
  
  delegate :sale, :to => :sale_receipt, :allow_nil => true
  attr_accessor :line
  
  before_save :read_from_line, :find_product, :clear_cancelled
  
  scope :product_not_found, -> { where(product_id: nil) }
  
  def self.assign_product_by_alias(product_alias)
    self.where(product_name: product_alias.alias).update_all(product_id: product_alias.product_id)
  end
  
  def line
    self.sale_receipt.sale.file_content.lines[self.line_number]
  end
  
  def self.unrecognized_products(store)
    self.includes(:sale_receipt).includes(sale_receipt: :sale).references(sale_receipt: :sale).where(product_id: nil).where("sales.store_id = ?", store).group(:product_name)
  end
  
  def self.unrecognized_products?(store)
    self.unrecognized_products(store).any?
  end

  def self.by_product(options = {})
    options[:stores]          ||= Store.all
    options[:agregate]        ||= 'SUM'
    options[:value]           ||= 'value'
    options[:time_scope]      ||= 90.days
    options[:to]              ||= Sale::last_date(stores: options[:stores])
    begin
      options[:from]          ||= Date::parse(options[:to].to_s) - options[:time_scope]
      records = self.select("products.name AS product_name, #{options[:agregate].to_s}(sale_items.#{options[:value].to_s}) AS value, product_id")
                    .joins('JOIN sale_receipts ON sale_receipts.id = sale_items.sale_receipt_id')
                    .joins('JOIN sales ON sales.id = sale_receipts.sale_id')
                    .joins('LEFT OUTER JOIN products ON products.id = sale_items.product_id')
                    .where('datetime >= ? AND datetime <= ?', options[:from].to_s, options[:to].to_s)
                    .where(sales: { store_id: options[:stores].map{ |s| s.id.to_i } })
                    .group('product_name')
                    .order('value DESC')
          
      if options[:for_chart]
        @chart_data = records.first(13).map{ |r| [r.product_name, r.value] }
      else
        records
      end
    rescue
      nil    
    end
  end
  
  def self.by_category(options = {})
    options[:stores]          ||= Store.all
    options[:agregate]        ||= 'SUM'
    options[:value]           ||= 'value'
    options[:time_scope]      ||= 90.days
    options[:to]              ||= Sale::last_date(stores: options[:stores])
    
    begin
      options[:from]          ||= Date::parse(options[:to].to_s) - options[:time_scope]
      records = self.select("product_categories.name AS category, #{options[:agregate].to_s}(sale_items.#{options[:value].to_s}) AS value, product_categories.id")
                    .joins(:sale_receipt)
                    .joins(sale_receipt: :sale)
                    .joins(:product)
                    .joins(product: :category)
                    .where('datetime >= ? AND datetime <= ?', options[:from].to_s, options[:to].to_s)
                    .where(sales: { store_id: options[:stores].map{ |s| s.id.to_i } })
                    .group('product_categories.name')
                    .order('value DESC')
      
      if options[:for_chart]
        @chart_data = records.first(13).map{ |r| [r.category, r.value] }
      else
        self
      end
    rescue
      nil
    end
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
    self.product_name = stripped_line.gsub!(/[^0-9A-Za-z\s]/, '').chomp.strip
    
    if vat_rate
      self.net_value = self.value / (1 + self.vat_rate)
    end
  end
  
  def clear_cancelled
    if self.sale_receipt.cancelled
      self.quantity = 0
      self.value = 0
      self.net_value = 0
      true
    end
  end
end
