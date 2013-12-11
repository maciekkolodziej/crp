json.array!(@sale_receipts) do |sale_receipt|
  json.extract! sale_receipt, :sale_id, :number, :datetime, :value, :net_value, :cancelled
  json.url sale_receipt_url(sale_receipt, format: :json)
end
