require 'cucumber'
require 'capybara/cucumber'
require 'faraday'
require 'dalli'

# Sinatra modules
require_relative '../../lib/api'
require_relative '../../lib/webapp'

Capybara.app = Rack::Builder.parse_file(File.expand_path('../../../config.ru', __FILE__)).first

API = Faraday.new do |conn| conn.adapter :rack, Rack::URLMap.new({
    "/api" => MemcachedManager::API.new,
    "/" => MemcachedManager::Webapp.new
  })
end

MemcachedConfigs = { host: 'localhost', port: '11211' }
Memcached        = Dalli::Client.new("#{MemcachedConfigs[:host]}:#{MemcachedConfigs[:port]}")
