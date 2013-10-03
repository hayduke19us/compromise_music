Rails.application.config.middleware.use OmniAuth::Builder do
  provider :rdio, ENV["OMNIAUTH_CONSUMER_KEY"], ENV["OMNIAUTH_CONSUMER_SECRET"]
end