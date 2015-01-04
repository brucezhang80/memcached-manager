require 'cucumber'
require 'capybara/cucumber'
require 'faraday'
require 'dalli'
require 'rspec'
require 'rspec/expectations'
require 'capybara/poltergeist'
require 'sinatra'

Capybara.javascript_driver = :poltergeist

World(RSpec::Matchers)

# Files
Dir.glob("lib/**/*.rb").each do |file|
  require "./#{file}"
end

Capybara.app = Rack::Builder.parse_file(File.expand_path('../../../config.ru', __FILE__)).first

API = Faraday.new do |conn| conn.adapter :rack, Rack::URLMap.new({
    "/api" => MemcachedManager::API.new,
    "/" => MemcachedManager::Webapp.new
  })
end

MemcachedConfigs = { host: ENV['MEMCACHED_1_PORT_11211_TCP_ADDR'] || 'localhost', port: '11211' }
Memcached        = Dalli::Client.new("#{MemcachedConfigs[:host]}:#{MemcachedConfigs[:port]}")

