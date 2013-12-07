json.array!(@products) do |product|
  json.extract! product, :name, :unit_id, :active, :purchasable, :inventoried, :cost_price, :sellable, :register_code, :register_name, :category_id, :vat_rate_id
  json.url product_url(product, format: :json)
end
