json.array!(@stores) do |store|
  json.extract! store, :symbol, :name
  json.url store_url(store, format: :json)
end
