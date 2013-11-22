json.array!(@units) do |unit|
  json.extract! unit, :symbol, :name, :primary
  json.url unit_url(unit, format: :json)
end
