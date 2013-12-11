json.array!(@sale_items) do |sale_item|
  json.extract! sale_item, :sale_receipt_id, :product_id, :product_name, :quantity, :price, :value, :net_value, :vat_symbol, :vat_rate
  json.url sale_item_url(sale_item, format: :json)
end
