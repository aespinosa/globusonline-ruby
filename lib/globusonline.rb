require "rest_client"
require "openssl"

module GlobusOnline
  URL = "https://transfer.api.globusonline.org/v0.10"
  class API
    attr_reader :options

    def initialize(options = {})
      @options = options
      cert_file = options[:cert_file]
      key_file = options[:key_file]
      ca_file = options[:ca_file]
      saml_cookie = options[:saml_cookie]
      raise "pass either cookie or cert/key not both" if saml_cookie and (cert_file or key_file) 
      @resource = if cert_file and key_file then
          RestClient::Resource.new(URL,
            :headers => {"X-Transfer-API-X509-User" => @options[:user]},
            :ssl_client_cert => ::OpenSSL::X509::Certificate.new(File.read(cert_file)),
            :ssl_client_key => ::OpenSSL::PKey::RSA.new(File.read(key_file)),
            :ssl_ca_file => ca_file,
            :verify_ssl => ::OpenSSL::SSL::VERIFY_PEER)
      elsif saml_cookie then
          RestClient::Resource.new(URL,
            :headers => {cookie: "saml=\"#{saml_cookie}\""},
            :ssl_ca_file => ca_file,
            :verify_ssl => ::OpenSSL::SSL::VERIFY_PEER)
      end
    end

    def [](method)
      @resource[method]
    end

    def method_missing(method_sym, *args, &block)
      begin
        @resource[method_sym.to_s].get
      rescue RestClient::Exception
        super
      end
    end

    private 
    def authenticate(username, password)
    end
  end
end
