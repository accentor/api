json.extract! user, :id, :name, :permission
json.url user_url(user, format: :json)
json.auth_tokens_url auth_tokens_url(format: :json)
