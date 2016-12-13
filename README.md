# OmniAuth Authentiq

Official OmniAuth strategy for authenticating with an  Authentiq ID mobile app.
Sign up for [Authentiq](https://www.authentiq.com/register/?utm_source=github&utm_medium=readme&utm_campaign=omniauth) to obtain your application credentials.

## Installation

Add this line to your application's Gemfile

```ruby
gem 'omniauth-authentiq', '~> 0.2.0'
```

Then bundle:

    $ bundle install

# Basic Usage with Rails

```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET']
end
```

# Scopes

Authentiq gives you the capability to request certain data like name, email and address from the Authentiq ID app.
After the user consents, this information will be shared during authentication.
Requesting specific information or "scopes" as done by adding the scope parameters to the basic usage.

Depending on your implementation, you may also need to declare the redirect_uri parameter

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
- `aq:push` to request permission to sign in via Push Notifications in the Authentiq ID app

Append `~r` to a scope to explicitly require it from the user.

Append `~s` to phone or email scope to explicitly require a verified (signed) scope.

The `~s` and `~r` can be combined to `~rs` to indicate that the scope is both required and should be verified.


## Tests

Tests are coming soon.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AuthentiqID/omniauth-authentiq.
