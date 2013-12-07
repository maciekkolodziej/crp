json.array!(@product_prices) do |product_price|
  json.extract! product_price, :product_id, :store_id, :sale_price
  json.url product_price_url(product_price, format: :json)
end
