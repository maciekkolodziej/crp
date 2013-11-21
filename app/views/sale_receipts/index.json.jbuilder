json.array!(@sale_receipts) do |sale_receipt|
  json.extract! sale_receipt, :id, :sale_id, :number, :datetime, :value, :net_value, :cancelled, :salesman_id
  json.url sale_receipt_url(sale_receipt, format: :json)
end
