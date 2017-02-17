# OmniAuth Authentiq

Official [OmniAuth](https://github.com/omniauth/omniauth/wiki) strategy for authenticating with an  Authentiq ID mobile app ([iOS](https://itunes.apple.com/us/app/authentiq-id/id964932341),  [Android](https://play.google.com/store/apps/details?id=com.authentiq.authentiqid)).

Application credentials (YOUR_CLIENT_ID and YOUR_CLIENT_SECRET below) can be obtained [at Authentiq](https://www.authentiq.com/register/?utm_source=github&utm_medium=readme&utm_campaign=omniauth).

## Installation

Add this line to your application's Gemfile

```ruby
gem 'omniauth-authentiq', '~> 0.3.0'
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

You can read the wiki for more extensive infomation on how to use the Authentiq Omniauth strategy for your rails application

* [Homepage](https://github.com/AuthentiqID/omniauth-authentiq/wiki)
* [Installation and basic usage](https://github.com/AuthentiqID/omniauth-authentiq/wiki/Installation-and-basic-usage)
* [Scopes, redirect uri configuration and response data](https://github.com/AuthentiqID/omniauth-authentiq/wiki/Scopes,-redirect-URI-configuration-and-responses)
* [Remote Logout (Backchannel-logout)](https://github.com/AuthentiqID/omniauth-authentiq/wiki/Remote-logout)

## Tests

Tests are coming soon.

## Contributing

Bug reports and pull requests are welcome [here](https://github.com/AuthentiqID/omniauth-authentiq)
