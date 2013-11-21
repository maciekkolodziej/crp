json.array!(@users) do |user|
  json.extract! user, :email, :first_name, :last_name, :current_pos_id, :active
  json.url user_url(user, format: :json)
end
