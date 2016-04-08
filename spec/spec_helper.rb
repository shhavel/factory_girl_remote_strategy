require 'factory_girl_remote_strategy'
ENV['LIBRARY'] ||= 'webmock'
puts "HTTP requests are stabbed with library #{ENV['LIBRARY']}"
FactoryGirl::RemoteStrategy.stub_requests_with ENV['LIBRARY']
if ENV['LIBRARY'] == 'webmock'
  require 'webmock/rspec'
  WebMock.disable_net_connect!(allow_localhost: true)
else
  FakeWeb.allow_net_connect = false
end

FactoryGirl.find_definitions

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
