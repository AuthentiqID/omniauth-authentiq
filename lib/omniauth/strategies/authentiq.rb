require 'omniauth-oauth2'
require_relative 'helpers/helpers'
module OmniAuth
  module Strategies
    class Authentiq < OmniAuth::Strategies::OAuth2
      autoload :BackChannelLogoutRequest, 'omniauth/strategies/oidc/back_channel_logout_request'

      option :name, 'authentiq'

      option :client_options, {
          :site => 'https://connect.authentiq.io/',
          :authorize_url => 'https://connect.authentiq.io/authorize',
          :token_url => 'https://connect.authentiq.io/token'
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the
      # token or as a URI parameter). This may not be possible
      # with all providers.

      uid { raw_info['sub'] }

      info do
        {
            :name => (@raw_info['name'] unless @raw_info['name'].nil?),
            :first_name => (@raw_info['given_name'] unless @raw_info['given_name'].nil?),
            :last_name => (@raw_info['family_name'] unless @raw_info['family_name'].nil?),
            :email => (@raw_info['email'] unless @raw_info['email'].nil?),
            :phone => (@raw_info['phone_number'] unless @raw_info['phone_number'].nil?),
            :location => (@raw_info['address'] unless @raw_info['address'].nil?),
            :geolocation => (@raw_info['aq:location'] unless @raw_info['aq:location'].nil?)
        }.reject { |k, v| v.nil? }
      end

      extra do
        {
            :middle_name => (@raw_info['middle_name'] unless @raw_info['middle_name'].nil?),
            :email_verified => (@raw_info['email_verified'] unless @raw_info['email_verified'].nil?),
            :phone_type => (@raw_info['phone_type'] unless @raw_info['phone_type'].nil?),
            :phone_number_verified => (@raw_info['phone_number_verified'] unless @raw_info['phone_number_verified'].nil?),
            :locale => (@raw_info['locale'] unless @raw_info['locale'].nil?),
            :zoneinfo => (@raw_info['zoneinfo'] unless @raw_info['zoneinfo'].nil?)
        }.reject { |k, v| v.nil? }
      end

      def request_phase
        add_openid
        super
      end

      def raw_info
        @raw_info ||= decode_idtoken(access_token.params['id_token'])
        request.update_param('sid', @raw_info['sid'])
        @raw_info
      end

      def callback_url
        options[:callback_url] || (full_host + script_name + callback_path)
      end

      def callback_phase
        should_sign_out? ? sign_out_phase : super
      end

      def add_openid
        unless options.scope.split.include? 'openid'
          options.scope = options.scope.split.push('openid').join(' ')
        end
      end

      def decode_idtoken(idtoken)
        (JWT.decode idtoken, @options.client_secret, true, {
            :algorithm => helpers.algorithm(@options),
            :iss => @options.client_options.site,
            :verify_iss => true,
            :aud => @options.client_id,
            :verify_aud => true,
            :verify_iat => true,
            :verify_jti => false,
            :verify_sub => true,
            :leeway => 60
        })[0]
      end

      def should_sign_out?
        request.post? && request.params.has_key?('logout_token')
      end

      def sign_out_phase
        backchannel_logout_request.new(self, request).call(options)
      end

      private

      def backchannel_logout_request
        BackChannelLogoutRequest
      end

      def helpers
        Helpers
      end
    end
  end
end