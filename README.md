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

## Initialization

Add this in `spec/spec_helper.rb` for use with WebMock

```ruby
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
FactoryGirl::RemoteStrategy.stub_requests_with :webmock # default
```

If you do not use RSpec for more info please see [WebMock README](https://github.com/bblimke/webmock)

Add this in the helper method for your tests suite (for RSpec `spec/spec_helper.rb`) for use with FakeWeb

```ruby
require 'fakeweb'
FakeWeb.allow_net_connect = false
FactoryGirl::RemoteStrategy.stub_requests_with :fakeweb
```

## Usage

Stubbing remote entities:

```ruby
group = FactoryGirl.remote(:group, id: 4, name: "Cats & Dogs")
```

where `Group` is `ActiveResource` model.

Making request:

```ruby
group = Group.find(4) # Remote HTTP request stubbed
group.name # => "Cats & Dogs"
```

Stub 404 error:

```ruby
FactoryGirl.remote_not_found(:incident, id: 1)
```

Find remote entity:

```ruby
Incident.find(1) # => raises ActiveResource::ResourceNotFound
```

Stub remote search request:

```ruby
dougal = Staff.new(name: "Dougal")
ted = Staff.new(name: "Ted")

remote_search [dougal, ted], group_id_eq: 4
```

Perform searching:

```ruby
Staff.find(:all, params: { group_id_eq: 4 }).to_a.
  map(&:name) # => ["Dougal", "Ted"]
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
