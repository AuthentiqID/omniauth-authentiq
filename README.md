# OmniAuth Authentiq

Official [OmniAuth](https://github.com/omniauth/omniauth/wiki) strategy for authenticating with an  Authentiq ID mobile app ([iOS](https://itunes.apple.com/us/app/authentiq-id/id964932341),  [Android](https://play.google.com/store/apps/details?id=com.authentiq.authentiqid)).
Application credentials can be obtained [at Authentiq](https://www.authentiq.com/register/?utm_source=github&utm_medium=readme&utm_campaign=omniauth).

## Installation

Add this line to your application's Gemfile

```ruby
gem 'omniauth-authentiq', '~> 0.2.2'
```

Then bundle:

    $ bundle install

# Basic Usage with Rails

```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'],
           scope: 'aq:name email~rs aq:push',
           enable_remote_sign_out: false
end
```

# Scopes and redirect uri configuration

Authentiq adds the capability to request personal information like name, email, phone number, and address from the Authentiq ID app ([iOS](https://itunes.apple.com/us/app/authentiq-id/id964932341),  [Android](https://play.google.com/store/apps/details?id=com.authentiq.authentiqid)).
During authentication, and only after the user consents, this information will be shared by the Authentiq ID app.

Requesting specific information or "scopes" is done by modifying the `scope` parameter in the basic usage example above.
Depending on your implementation, you may also need to provide the `redirect_uri` parameter. 

Example:
```ruby
use OmniAuth::Builder do
  provider :authentiq, ENV['AUTHENTIQ_KEY'], ENV['AUTHENTIQ_SECRET'], 
           scope: 'aq:name email~rs aq:push phone address',
           enable_remote_sign_out: false
end
```

Available scopes are: 
- `aq:name` for name, providing `:name`, `:first_name`, `:last_name` and additionally `:middle_name` will be available in `:extra`
- `email` providing `:email` and additionally `:email_verified` will be available in `:extra`
- `phone` providing `:phone` and additionally `:phone_type` and `:phone_number_verified` will be available in `:extra`
- `address` providing `:location` with the following format: 
```ruby
"location" => {
    "country" => "Country",
    "formatted" => "Street\nCity\nPostal Code\nState\nCountry",
    "locality" => "City",
    "postal_code" => "Postal Code",
    "state" => "State",
    "street_address" => "Street"
}
```
- `aq:location` providing `:geolocation` (geo coordinates and address from a reverse lookup) with the following format: 
```ruby
"geolocation" => {
    "accuracy" => 20.509,
    "address" => {
        "country" => "Geo country",
        "formatted" => "Geo street\nGeo city\nGeo postal_code\nGeo country",
        "locality" => "Geo city",
        "postal_code" => "Geo postal_code",
        "street_address" => "Geo street"
    },
    "altitude" => 0.0,
    "latitude" => 55.340157,
    "longitude" => -30.555491,
    "speed" => 0.0
}
```
- `aq:push` to request permission to sign in via Push Notifications in the Authentiq ID app

`:locale` and `:zoneinfo` will be available in `:extra` regardless of the requested scopes. The format of these strings is:
- `locale` providing `:locale` in the `language_territory` format
- `zoneinfo` providing `:zoneinfo` in the `Continent/City` format

Append `~r` to a scope to explicitly require it from the user.

Append `~s` to phone or email scope to explicitly require a verified (signed) scope.

The `~s` and `~r` can be combined to `~rs` to indicate that the scope is both required and should be / have been verified.

# Response data
An example complete response, in the form of a ruby hash, after requesting all possible scopes would be:

```ruby
{
    "provider" => "authentiq",
    "uid" => "E1YcKg143eO6Z-e-3vK1GBJEGpKlIpX1-BbeA3GY6II",
    "sid" => "E1YcKg143eO6Z-e-3vK1GBJEGpKlIpX1-BbeA3GY6II"
    "info" => {
        "name" => "First Middle Last",
        "first_name" => "First",
        "last_name" => "Last",
        "email" => "user@host.com",
        "phone" => "+15417543010",
        "location" => {
            "country" => "Country",
            "formatted" => "Street\nCity\nPostal Code\nState\nCountry",
            "locality" => "City",
            "postal_code" => "Postal Code",
            "state" => "State",
            "street_address" => "Street"
        },
        "geolocation" => {
            "accuracy" => 20.509,
            "address" => {
                "country" => "Geo country",
                "formatted" => "Geo street\nGeo city\nGeo postal_code\nGeo country",
                "locality" => "Geo city",
                "postal_code" => "Geo postal_code",
                "street_address" => "Geo street"
            },
            "altitude" => 0.0,
            "latitude" => 55.340157,
            "longitude" => -30.555491,
            "speed" => 0.0
        }
    },
    "credentials" => {
        "token" => "gVh3XACpE3pchcV7f9jcAJOurRE7pN",
        "refresh_token" => "5xqib7u9u79HbRoXXqom7V9REtxhzt",
        "expires_at" => 1481706571,
        "expires" => true
    },
    "extra" => {
        "middle_name" => "Middle",
        "email_verified" => true,
        "phone_type" => "mobile",
        "phone_number_verified" => true,
        "locale" => "language_territory", #eg en_US
        "zoneinfo" => "Continent/City" #eg Europe/Amsterdam
    }
}
```

## Remote Logout (Backchannel-logout)
Authentiq Omniauth strategy provides the ability to log out remotely via the Authentiq ID app by providing a proc/lambda for the `enable_remote_sign_out` option.

To test the remote logout functionality in Rails under a development environment you need to enable rails caching for development environment

#### Example with Devise and Omniauth-Authentiq ([demo](https://devise-omniauth-demo.herokuapp.com))

Add Authentiq configuration  and the relevant proc/lambda (to check and delete the Authentiq session when a logout request arrives) in the `config/initializers/devise.rb` file
```ruby
config.omniauth :authentiq, ENV["AUTHENTIQ_APP_ID"], ENV["AUTHENTIQ_APP_SECRET"], 
                {
                scope: 'aq:name email~rs address phone aq:push',
                enable_remote_sign_out: (
                    lambda do |request|
                      if Rails.cache.read("application_name:#{:authentiq}:#{request.params['sid']}").present?
                        Rails.cache.delete("application_name:#{:authentiq}:#{request.params['sid']}")
                        true
                      else
                        false
                      end
                    end
                  )
                }
```
Add a check to save the session in the `authentiq` function that should exist in the  `app/controllers/users/omniauth_callbacks_controller.rb` file as suggested by [Devise](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview) when using it in conjunction with omniauth (single or multiple providers)
```ruby
    if params['sid']
      Rails.cache.write("application_name:#{:authentiq}:#{params['sid']}", params['sid'], expires_in: 28800)
      session[:authentiq_tickets] ||= {}
      session[:authentiq_tickets][:authentiq] = params['sid']
    end
```

Add an action to validate the Authentiq session on the `app/controllers/application_controller.rb` file
```ruby
  before_action :validate_authentiq_session!
  protect_from_forgery with: :exception

  def validate_authentiq_session!
    return unless signed_in? && session[:authentiq_tickets]

    valid = session[:authentiq_tickets].all? do |provider, session|
      Rails.cache.read("application_name:#{provider}:#{session}").present?
    end

    unless valid
      session[:authentiq_tickets] = nil
      sign_out current_user
      redirect_to new_user_session_path
    end
  end
```

 
#### Example only with Omniauth-Authentiq ([demo](https://just-omniauth-demo.herokuapp.com/))
Add Authentiq configuration  and the relevant proc/lambda (to check and delete the Authentiq session when a logout request arrives) in the `config/initializers/omniauth.rb` file.
```ruby
  provider :authentiq, ENV["AUTHENTIQ_APP_ID"], ENV["AUTHENTIQ_APP_SECRET"],
           {
              scope: 'aq:name email~rs aq:push phone address',
              enable_remote_sign_out: (
                lambda do |request|
                  if Rails.cache.read("application_name:#{:authentiq}:#{request.params['sid']}").present?
                    Rails.cache.delete("application_name:#{:authentiq}:#{request.params['sid']}")
                    true
                  else
                    false
                  end
                end
              )
           }

```
Add a check to save the session in the function that creates the session in the  `app/controllers/sessions_controller.rb` file
```ruby
    if params['sid']
      Rails.cache.write("application_name:#{:authentiq}:#{params['sid']}", params['sid'], expires_in: 28800)
      session[:authentiq_tickets] ||= {}
      session[:authentiq_tickets][:authentiq] = params['sid']
    end
```
Add an action to validate the Authentiq session on the `app/controllers/application_controller.rb` file
```ruby
  before_action :validate_authentiq_session!
  protect_from_forgery with: :exception

  def validate_authentiq_session!
    return unless current_user && session[:service_tickets]

    valid = session[:service_tickets].all? do |provider, ticket|
      Rails.cache.read("omnivise:#{provider}:#{ticket}").present?
    end

    unless valid
      session[:service_tickets] = nil
      reset_session
      redirect_to root_path
    end
  end
```

## Tests

Tests are coming soon.

## Contributing

Bug reports and pull requests are welcome [here](https://github.com/AuthentiqID/omniauth-authentiq)
