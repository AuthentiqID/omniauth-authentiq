# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/authentiq/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-authentiq"
  spec.version       = OmniAuth::Authentiq::VERSION
  spec.authors       = ["Alexandros Keramidas"]
  spec.email         = ["alex@authentiq.com", "support@authentiq.com"]

  spec.summary       = %q{Authentiq strategy for OmniAuth}
  spec.description   = %q{Strategy to enable passwordless authentication in OmniAuth via Authentiq.}
  spec.homepage      = "https://github.com/AuthentiqID/omniauth-authentiq"
  spec.licenses      = %w(MIT)

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.3', '>= 1.3.1'
end
