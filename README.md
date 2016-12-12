# OmniAuth Authentiq

Official OmniAuth strategy for authenticating with AuthentiqID. Sign up for [Authentiq](https://www.authentiq.com/register/?utm_source=github&utm_medium=readme&utm_campaign=omniauth) to obtain your application credentials.

## Installation

Add this line to your application's Gemfile

```ruby
gem 'omniauth-authentiq', '~> 0.2.0'
```

Then bundle:

    $ bundle install

# Basic Usage

```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET']
end
```


# Scopes

Authentiq gives you the capability to request various data from the user. This is done by adding the scope parameters to the basic usage.

Depending on your implementation, you may need to declare the redirect_uri parameter

```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'], 
           scope: 'aq:name email~rs aq:push phone address',
           redirect_uri: 'redirect_uri'
end
```

Available scopes are: 
- `aq:name` for Name
- `email` for Email
- `phone` for Phone
- `address` for Address
- `aq:location` for Location (Coordinates and geolocated address)

Append `~r` to a scope to explicitly require it from the user.

Append `~s` or `~rs` to phone or email scope to explicitly require a signed and/or verified scope from the user.

To enable login via Push Notifications in the Authentiq ID mobile app, add `aq:push` to the list of scopes.

## Tests

Tests are coming soon.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://gitlab.com/authentiq/omniauth-authentiq.

