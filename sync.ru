# Run with: rackup sync.ru -E production
require "bundler/setup"
require "yaml"
require "faye"
require "sync"

Sync.load_config(
  File.expand_path("../config/sync.yml", __FILE__),
  ENV["RAILS_ENV"] || "development"
)

run Sync.pubsub_app
