# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/authentiq/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-authentiq"
  spec.version       = OmniAuth::Authentiq::VERSION
  spec.authors       = ["Alexandros Keramidas"]
  spec.email         = ["alex@authentiq.com"]

  spec.summary       = %q{Authentiq OAuth2 strategy for OmniAuth}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/AuthentiqID/omniauth-authentiq"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.3.1'
end
