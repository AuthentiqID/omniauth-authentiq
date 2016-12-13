# OmniAuth Authentiq

Official [OmniAuth](https://github.com/omniauth/omniauth/wiki) strategy for authenticating with an  Authentiq ID mobile app ([iOS](https://itunes.apple.com/us/app/authentiq-id/id964932341),  [Android](https://play.google.com/store/apps/details?id=com.authentiq.authentiqid)).
Application credentials can be obtained [at Authentiq](https://www.authentiq.com/register/?utm_source=github&utm_medium=readme&utm_campaign=omniauth).

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
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'],
           scope: 'aq:name email~rs aq:push'
end
```

# Scopes

Authentiq adds the capability to request personal information like name, email, phone number, and address from the Authentiq ID app ([iOS](https://itunes.apple.com/us/app/authentiq-id/id964932341),  [Android](https://play.google.com/store/apps/details?id=com.authentiq.authentiqid)).
During authentication, and only after the user consents, this information will be shared by the Authentiq ID app.

Requesting specific information or "scopes" is done by modifying the `scope` parameter in the basic usage example above.
Depending on your implementation, you may also need to provide the `redirect_uri` parameter. 

Example:
```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'], 
           scope: 'aq:name email~rs aq:push phone address',
           redirect_uri: '<REDIRECT_URI>'
end
```

Available scopes are: 
- `aq:name` for name, providing :name :first_name :last_name and additionally :middle_name will be available in :extra
- `email` providing :email and additionally :email_verified will be available in :extra
- `phone` providing :phone and additionally :phone_type and :phone_number_verified will be available in :extra
- `address` providing :location with the following format: XXX
- `aq:location` providing :geolocation (geo coordinates and address from a reverse lookup) with the following format: XXX
- `aq:push` to request permission to sign in via Push Notifications in the Authentiq ID app

:locale and :zoneinfo will be available in :extra regardless of the requested scopes. The format of these strings is:
- locale XXX
- zoneinfo XXX

Append `~r` to a scope to explicitly require it from the user.

Append `~s` to phone or email scope to explicitly require a verified (signed) scope.

The `~s` and `~r` can be combined to `~rs` to indicate that the scope is both required and should be / have been verified.


## Tests

Tests are coming soon.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AuthentiqID/omniauth-authentiq.
