json.array!(@sales) do |sale|
  json.extract! sale, :store_id, :date, :number, :value, :vat, :receipts_count, :cancelled_receipts_count, :cancelled_receipts_value
  json.url sale_url(sale, format: :json)
end
