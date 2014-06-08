require "factory_girl_remote_strategy"
require "fakeweb"

FakeWeb.allow_net_connect = false

FactoryGirl.find_definitions

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
