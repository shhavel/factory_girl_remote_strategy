# factory_girl_remote_strategy

FactoryGirl strategy for ActiveResource models.
Stubs remote HTTP requests with [WebMock](https://github.com/bblimke/webmock) or [FakeWeb](https://github.com/chrisk/fakeweb)

## Installation

Add this line to your application's Gemfile:

    gem 'factory_girl_remote_strategy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factory_girl_remote_strategy

## Usage with WebMock and RSpec

Add this in `spec/spec_helper.rb`

```ruby
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
FactoryGirl::RemoteStrategy.stub_requests_with :webmock
```

If you do not use RSpec for more info please see [WebMock README](https://github.com/bblimke/webmock)

## Usage with FakeWeb

Add this in the helper method for your tests suite (for RSpec `spec/spec_helper.rb`)

```ruby
require 'fakeweb'
FakeWeb.allow_net_connect = false
FactoryGirl::RemoteStrategy.stub_requests_with :fakeweb
```

## Contributing

1. Fork it ( http://github.com/shhavel/factory_girl_remote_strategy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

```ruby
LIBRARY=webmock rspec
LIBRARY=fakeweb rspec
```
