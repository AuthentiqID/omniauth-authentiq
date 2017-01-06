module OmniAuth
  module Strategies
    class Authentiq
      class BackChannelLogoutRequest

        def initialize(strategy, request)
          @strategy, @request = strategy, request
        end

        def call(options = {})
          @options = options

          begin
            # for
            # sign_out_callback.call(*back_channel_logout_request)
            # to actually happen
            # a proc must be set in the devise.rb initializer of the rails app
            result = sign_out_callback.call(*back_channel_logout_request)
          rescue
            return backchannel_logout_response(400, ['Bad request']).finish
          else
            if result
              result = backchannel_logout_response(200, ['OK'])
            else
              result = backchannel_logout_response(501, ['Not implemented'])
            end
          ensure
            return unless result
            return result.finish
          end
        end

        private

        def back_channel_logout_request
          @logout_request || begin
            decode_logout_token(@request.params['logout_token'])
            @request
          end
        end

        def decode_logout_token(logout_token)
            logout_jwt = JWT.decode logout_token, @options.client_secret, true, {:algorithm => 'HS256'}
            if validate_logout_token(logout_jwt)
              @request.update_param('user_id', logout_jwt[0]['sub'])
            end
        end

        def validate_logout_token(logout_jwt)
          valid = false
          begin
            if logout_jwt[0].key?('iss') &&
                logout_jwt[0].key?('sub') &&
                logout_jwt[0].key?('aud') &&
                logout_jwt[0].key?('iat') &&
                logout_jwt[0].key?('jti') &&
                logout_jwt[0].key?('events') &&
                logout_jwt[0]['events'][0] == 'http://schemas.openid.net/event/backchannel-logout' &&
                !logout_jwt[0].key?('nonce')
              valid = true
            end
            valid
          end
        end

        def sign_out_callback
          @options[:enable_remote_sign_out]
        end

        def backchannel_logout_response(code, body)
          response = Rack::Response.new
          response.status = code
          response['Cache-Control'] = 'no-cache, no-store'
          response['Pragma'] = 'no-cache'
          response.body = body
          response
        end
      end
    end
  end
end