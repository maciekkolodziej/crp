json.array!(@vat_rates) do |vat_rate|
  json.extract! vat_rate, :symbol, :rate
  json.url vat_rate_url(vat_rate, format: :json)
end
