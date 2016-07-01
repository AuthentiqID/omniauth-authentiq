# OmniAuth Authentiq

Official OmniAuth strategy for authenticating with AuthentiqID.
In order to use it, you will need to sign up for and Applications Key and Secret on the [Authentiq registrations page](https://www.authentiq.com/register/)

## Installation

Add this line to your application's Gemfile (local path for now as it is not on rubygems repo):

```ruby
gem 'omniauth-authentiq', '~> 0.2.0', :git => 'https://github.com/AuthentiqID/omniauth-authentiq.git'
```

Then install the gem:

    $ bundle

`caution: if using on a gitlab development installation, please install only this gem and don't update everything with bundle`

```$ gem install omniauth-authentiq```

# Basic Usage
```
use OmniAuth::Builder do
  provider :github, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET']
end
```

# Scopes
Authentiq gives you the capability to request various data from the user. This is done by adding the scope parameters in the basic usage.
If not added, the default scopes are Name, Email and Phone
```
use OmniAuth::Builder do
  provider :github, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'], scope: "space separated list of scopes" 
end
```

Available scopes are: 
- aq:name for Name
- email for Email
- phone for Phone
- address for Address
- aq:location for Location
- aq:push
- aq:link 

# Gitlab installation usage
After adding the gem to your gemfile

## Development Installation
To use the gem in a GitLab development installation enable the omniauth functionality and add the configuration to you gitlab.rb
```
- { name: 'authentiq',
   app_id: ENV['AUTHENTIQ_KEY'],
   app_secret: ENV['AUTHENTIQ_SECRET'],
   scope: 'space separated list of scopes' }
```

## Omnibus Installation
To use the gem in a GitLab Omnibus installation follow this link for general omniauth instructions http://docs.gitlab.com/ce/integration/omniauth.html

## Tests
Tests are not implemented yet

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AuthentiqID/omniauth-authentiq.

