require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Authentiq < OmniAuth::Strategies::OAuth2
      autoload :BackChannelLogoutRequest, 'omniauth/strategies/oidc/back_channel_logout_request'

      BASE_URL = 'https://connect.authentiq.io/'

      option :name, 'authentiq'

      option :client_options, {
          :site => BASE_URL,
          :authorize_url => '/authorize',
          :token_url => '/token',
          :info_url => '/userinfo'
      }

      option :authorize_options, [:scope]

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the
      # token or as a URI parameter). This may not be possible
      # with all providers.

      uid { raw_info['uid'] }

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
        @raw_info['uid'] = access_token.get(user_info_endpoint).parsed['sub']
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
        @info = JWT.decode idtoken, nil, false
        @info[0]
      end

      def should_sign_out?
        request.post? && request.params.has_key?('logout_token')
      end

      def sign_out_phase
        if options[:enable_remote_sign_out]
          backchannel_logout_request.new(self, request).call(options)
        end
      end

      def user_info_endpoint
        @options.client_options[:info_url]
      end

      private

      def backchannel_logout_request
        BackChannelLogoutRequest
      end
    end
  end
end