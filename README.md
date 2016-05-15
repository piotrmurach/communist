# Communist
[![Gem Version](https://badge.fury.io/rb/communist.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/communist.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/piotrmurach/communist.svg?travis)][gemnasium]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty-command.svg?branch=master)][inchpages]

[gem]: http://badge.fury.io/rb/communist
[travis]: http://travis-ci.org/piotrmurach/communist
[gemnasium]: https://gemnasium.com/piotrmurach/communist
[inchpages]: http://inch-ci.org/github/piotrmurach/communist

The Manifesto:

> It is Communist prime role to serve community by providing Cucumber steps for
> testing external API calls from command line applications. To meet this aim
> the Communist employees Sinatra DSL for mocking server responses. The Communist
> server receives requests from CLI and provides an API to respond to those
> requests. Canned answers/expectations have to be provided upfront.

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

Further, by including `aruba` cucumber steps and using `sinatra` dsl you can easily describe canned responses:

```ruby
Scenario: List watchers
  Given the GitHub API server:
  """
  get('/repos/wycats/thor/subscribers') {
    body :login => 'octokit', :id => 1,
          :url => 'https://api.github.com/users/piotrmurach'
    status 200
  }
  """
  When I successfully run `gcli watch ls wycats thor`
  Then the stdout should contain "octokit"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2012-2016 Piotr Murach. See LICENSE for further details.
