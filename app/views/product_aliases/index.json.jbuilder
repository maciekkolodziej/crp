json.array!(@product_aliases) do |product_alias|
  json.extract! product_alias, :product_id, :alias
  json.url product_alias_url(product_alias, format: :json)
end
