json.array!(@takings) do |taking|
  json.extract! taking, :store_id, :date, :value, :card_payments, :cash_payments
  json.url taking_url(taking, format: :json)
end
