json.extract! auth_token, :id, :device_id, :user_agent
json.url auth_token_url(auth_token, format: :json)
json.user_url user_url(auth_token.user, format: :json)
