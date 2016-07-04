# OmniAuth Authentiq

Official OmniAuth strategy for authenticating with AuthentiqID. Sign up for [Authentiq](https://www.authentiq.com/register/?utm_source=github&utm_medium=readme&utm_campaign=omniauth) to obtain your application credentials.

## Installation

Add this line to your application's Gemfile (local path for now as it is not on rubygems repo):

```ruby
gem 'omniauth-authentiq', '~> 0.2.0', :git => 'https://github.com/AuthentiqID/omniauth-authentiq.git'
```

Then bundle:

    $ bundle

# Basic Usage

```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET']
end
```

# Scopes

Authentiq gives you the capability to request various data from the user. This is done by adding the scope parameters to the basic usage. If not added, the default scopes are Name, Email and Phone. Other available options are display and redirect uri. Also you can configure the endpoint the gem uses

```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'], 
           scope: 'aq:name email~r aq:push',
           display: 'modal',
           redirect_uri: 'redirect_uri',
           client_options: {
               site: 'authentiq endpoint'
           }
end
```

Available scopes are: 

- `aq:name` for Name
- `email` for Email
- `phone` for Phone
- `address` for Address
- `aq:location` for Location
- `aq:push`
- `aq:link` 

# Gitlab installation usage

After adding the gem to your gemfile.

## Development Installation

To use the gem in a GitLab development installation enable the omniauth functionality and add the configuration to you gitlab.rb.

```yaml
- { 
   name: 'authentiq',
   app_id: ENV['AUTHENTIQ_KEY'],
   app_secret: ENV['AUTHENTIQ_SECRET'],
   args: { 
           scope: 'aq:name email~r aq:push',
           display: 'modal',
           redirect_uri: '<<your_redirect_uri>>',
           client_options: {
               site: 'https://connect.authentiq.io/'
           }
         }
   }
```

## Omnibus Installation

To use the gem in a GitLab Omnibus installation follow this link for general omniauth instructions http://docs.gitlab.com/ce/integration/omniauth.html

## Tests

Tests are coming soon.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AuthentiqID/omniauth-authentiq.

