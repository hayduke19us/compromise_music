CONSUMER_KEY = 'vc76wjg3xyyqawc7m7dttjmq'
CONSUMER_SECRET = 'NxMYesjNWW'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :rdio, CONSUMER_KEY, CONSUMER_SECRET
end