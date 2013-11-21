json.array!(@sales) do |sale|
  json.extract! sale, :company_id, :pos_id, :date, :number, :value, :vat, :net_value, :receipt_count, :created_by, :updated_by
  json.url sale_url(sale, format: :json)
end
