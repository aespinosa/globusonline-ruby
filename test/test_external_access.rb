require 'test/unit'

class ExternalAccessTest < Test::Unit::TestCase
  def test_net_http_proxy
    x509_file = "/tmp/x509up_u#{Process.uid}"
    skip
    require "net/http"
    uri = URI.parse "https://transfer.api.globusonline.org/v0.10/tasksummary"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    #cert_file = x509_file
    #key_file = x509_file
    cert_file = "/home/aespinosa/.globus/usercert.pem"
    key_file = "/home/aespinosa/.globus/userkey.pem"
    http.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
    http.key = OpenSSL::PKey::RSA.new(File.read(key_file))
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.ca_file = "/home/aespinosa/globus/certificates/gd-bundle_ca.cert"
    req = Net::HTTP::Get.new(uri.request_uri)
    req["X-Transfer-API-X509-User"] = "aespinosa"

    res = http.request(req)
    puts res.body
  end

  def test_curl
    x509_file = "/tmp/x509up_u#{Process.uid}"
    skip 'No proxy file found' if not File.exist?(x509_file)
    require 'curb'
    url =  "https://transfer.api.globusonline.org/v0.10/tasksummary"
    Curl::Easy.new(url) do |curl|
      curl.headers["X-Transfer-API-X509-User"] = "aespinosa"
      cert_file = x509_file
      key_file = x509_file
      #cert_file = "/home/aespinosa/.globus/usercert.pem"
      #key_file = "/home/aespinosa/.globus/userkey.pem"
      curl.cacert = "/home/aespinosa/.globus/certificates/gd-bundle_ca.cert"
      curl.cert = cert_file
      curl.cert_key = key_file

      curl.verbose = true

      curl.perform
      puts curl.body_str
    end
  end
end
