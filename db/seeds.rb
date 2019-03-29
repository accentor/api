if Rails.env.development?
  user = User.create(name: 'charlotte', password: 'password', permission: :admin)
  token = AuthToken.create(user: user, user_agent: 'Rails')
  token.update(hashed_secret: BCrypt::Password.create('secret', cost: 1), device_id: 'device-id')
end
