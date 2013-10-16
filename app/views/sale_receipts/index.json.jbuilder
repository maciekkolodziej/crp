json.array!(@sale_receipts) do |sale_receipt|
  json.extract! sale_receipt, :sale_id, :number, :value, :item_count, :cancelled, :salesman_id
  json.url sale_receipt_url(sale_receipt, format: :json)
end
