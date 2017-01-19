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
            # for sign_out_callback.call(*back_channel_logout_request) to execute
            # a proc must be set in the devise.rb initializer of the rails app
            result = sign_out_callback.call(*back_channel_logout_request)
          rescue StandardError => err
            result = back_channel_logout_response(400, [err.to_s])
          else
            if result
              result = back_channel_logout_response(200, ['Logout succeeded'])
            else
              result = back_channel_logout_response(501, ['Authentiq session does not exist'])
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
          begin
            logout_jwt = JWT.decode logout_token, @options.client_secret, true, {
                :algorithm => algorithm,
                :iss => issuer,
                :verify_iss => true,
                :aud => @options.client_id,
                :verify_aud => true,
                :verify_iat => true,
                :verify_jti => true,
                :verify_sub => true,
                :leeway => 60
            }
            if validate_events(logout_jwt[0]) && validate_nonce(logout_jwt[0])
              @request.update_param('sid', logout_jwt[0]['sid'])
            else
              raise 'Logout JWT missing events claim or nonce claim is present'
            end
          end
        end

        def validate_events(logout_jwt)
          logout_jwt.key?('events') &&
              (logout_jwt['events'][0] == 'http://schemas.openid.net/event/backchannel-logout' ||
                  logout_jwt['events']['http://schemas.openid.net/event/backchannel-logout'].empty?)
        end

        def validate_nonce(logout_jwt)
          !logout_jwt.key?('nonce')
        end

        def sign_out_callback
          @options[:enable_remote_sign_out]
        end

        def back_channel_logout_response(code, body)
          response = Rack::Response.new
          response.status = code
          response['Cache-Control'] = 'no-cache, no-store'
          response['Pragma'] = 'no-cache'
          response.headers['Content-Type'] = 'text/plain; charset=utf-8'
          response.body = body
          response
        end

        def issuer
          @options.issuer.nil? ? 'https://connect.authentiq.io/' : @options.issuer
        end

        def algorithm
          if @options.algorithm != nil && (%w(HS256 RS256 ES256).include? @options.client_signed_response_alg)
            @options.client_signed_response_alg
          else
            'HS256'
          end
        end
      end
    end
  end
end