json.array!(@database_resets) do |database_reset|
  json.extract! database_reset, :ip, :hostname, :created_at, :updated_at
  json.url database_reset_url(database_reset, format: :json)
end
