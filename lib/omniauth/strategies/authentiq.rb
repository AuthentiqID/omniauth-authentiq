require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Authentiq < OmniAuth::Strategies::OAuth2
      #Set the base URL
      BASE_URL = 'https://connect.authentiq.io/'

      # Authentiq strategy name
      option :name, 'authentiq'

      # Build the basic client options (url, authorization url, token url)
      option :client_options, {
          :site => BASE_URL,
          :authorize_url => '/authorize',
          :token_url => '/token'
      }

      # Get options from parameters
      option :authorize_options, [:scope, :display]

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.

      # Get the user id from raw info
      uid{ raw_info['sub'] }

      info do
        {
            :name => raw_info['name'],
            :email => raw_info['email'],
            :phone => raw_info['phone_number']
        }
      end

      extra do {
          :given_name => raw_info['given_name'],
          :middle_name => raw_info['middle_name'],
          :family_name => raw_info['family_name'],
          :email_verified => @raw_info['email_verified'],
          :phone_type => raw_info['phone_type'],
          :phone_number_verified => raw_info['phone_number_verified'],
          :locale => @raw_info['locale'],
          :zoneinfo => @raw_info['zoneinfo']
      }
      end

      def raw_info
        @raw_info ||= access_token.get('/userinfo').parsed
      end

      # Over-ride callback_url definition to maintain
      # compatibility with omniauth-oauth2 >= 1.4.0
      #
      # See: https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
          # Fixes regression in omniauth-oauth2 v1.4.0 by https://github.com/intridea/omniauth-oauth2/commit/85fdbe117c2a4400d001a6368cc359d88f40abc7
          options[:callback_url] || (full_host + script_name + callback_path)
      end

    end
  end
end
