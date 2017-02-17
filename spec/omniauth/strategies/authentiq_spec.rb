require 'spec_helper'
require 'omniauth-authentiq'
require 'simplecov'

describe OmniAuth::Strategies::Authentiq do
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }
  let(:app) {
    lambda do
      [200, {}, ["Hello."]]
    end
  }

  subject do
    OmniAuth::Strategies::Authentiq.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client_options' do
    it 'has correct site' do
      expect(subject.client.site).to eq('https://connect.authentiq.io/')
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('/authorize')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('/token')
    end

    describe "overrides" do
      it 'should allow overriding the site' do
        @options = {:client_options => {'site' => 'https://dev.connect.authentiq.io'}}
        expect(subject.client.site).to eq('https://dev.connect.authentiq.io')
      end

      it 'should allow overriding the authorize_url' do
        @options = {:client_options => {'authorize_url' => '/some-branch/authorize'}}
        expect(subject.client.options[:authorize_url]).to eq('/some-branch/authorize')
      end

      it 'should allow overriding the token_url' do
        @options = {:client_options => {'token_url' => '/some-branch/token'}}
        expect(subject.client.options[:token_url]).to eq('/some-branch/token')
      end

      it 'should allow overriding the jwt_issuer' do
        @options = {:client_options => {'jwt_issuer' => 'https://dev.connect.authentiq.io/some-branch'}}
        expect(subject.client.options[:jwt_issuer]).to eq('https://dev.connect.authentiq.io/some-branch')
      end
    end
  end

  describe "#authorize_options" do
    [:scope].each do |k|
      it "should support #{k}" do
        @options = {k => 'aq:name email~rs address phone aq:push'}
        expect(subject.authorize_params[k.to_s]).to eq('aq:name email~rs address phone aq:push')
      end
    end
  end


  describe "callback_url" do
    it 'should default to nil' do
      @options = {}
      expect(subject.authorize_params['redirect_uri']).to eq(nil)
    end

    it 'should set the callback_url parameter if present' do
      @options = {:callback_url => 'https://example.com/users/auth/authentiq/callback'}
      expect(subject.options['callback_url']).to eq('https://example.com/users/auth/authentiq/callback')
    end
  end
end