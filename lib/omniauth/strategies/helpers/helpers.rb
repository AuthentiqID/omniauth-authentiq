class Helpers
  def self.algorithm(options = {})
    @options = options
    if @options.algorithm != nil && (%w(HS256 RS256 ES256).include? @options.client_signed_response_alg)
      @options.client_signed_response_alg
    else
      'HS256'
    end
  end
end