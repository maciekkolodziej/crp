json.array!(@roles) do |role|
  json.extract! role, :name, :global
  json.url role_url(role, format: :json)
end
