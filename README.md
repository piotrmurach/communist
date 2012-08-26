# Communist

The Manifesto:

>It is Communist prime role to serve community by providing Cucumber steps for
>testing external API calls from command line applications. To meet this aim
>the Communist employees Sinatra DSL for mocking server responses. The Communist
>server receives requests from CLI and provides an API to respond to those
>requests. Canned answers/exectations have to provided upfront.

## Installation

Add this line to your application's Gemfile:

    gem 'communist'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install communist

## Usage

To get started include the following in your cucumber environment file:

```ruby
# features/support/env.rb
require 'communist/cucumber'
```

The gem uses `ENV['TEST_HOST']` variable to instrument requests. In your command line application add the following logic to switch between live and test requests:

```ruby
if ENV['TEST_HOST']
  @@api.endpoint = 'http://' + ENV['TEST_HOST']
end
```

Finally, communist has few cucumber steps such as `Given ... server:` that help setting expectations such as:

```ruby
Scenario: Get blob
  Given the GitHub API server:
  """
  get('/repos/wycats/thor/git/blobs/59b23de9b91d') { status 200 }
  """
  When I run `ghub blob get wycats thor 59b23de9b91d`
  Then the exit status should be 0
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Piotr Murach. See LICENSE for further details.
