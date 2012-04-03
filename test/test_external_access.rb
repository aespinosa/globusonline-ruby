require 'test/unit'
require 'json'

class ExternalAccessTest < Test::Unit::TestCase
  def test_net_http_proxy
    x509_file = "/tmp/x509up_u#{Process.uid}"
    skip 'No proxy file found' if not File.exist?(x509_file)
    require "net/http"
    uri = URI.parse "https://transfer.api.globusonline.org/v0.10/tasksummary"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    cert_file = x509_file
    key_file = x509_file
    #cert_file = "#{ENV['HOME']}/.globus/usercert.pem"
    #key_file = "#{ENV['HOME']}/.globus/userkey.pem"
    http.cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
    http.key = OpenSSL::PKey::RSA.new(File.read(key_file))
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.ca_file = "#{ENV['HOME']}/.globus/certificates/gd-bundle_ca.cert"
    req = Net::HTTP::Get.new(uri.request_uri)
    req["X-Transfer-API-X509-User"] = ENV["USER"]

    res = http.request(req)
    assert_equal "tasksummary", JSON.parse(res.body)['DATA_TYPE']
  end

  def test_curl
    x509_file = "/tmp/x509up_u#{Process.uid}"
    skip 'No proxy file found' if not File.exist?(x509_file)
    require 'curb'
    url =  "https://transfer.api.globusonline.org/v0.10/tasksummary"
    Curl::Easy.new(url) do |curl|
      curl.headers["X-Transfer-API-X509-User"] = ENV["USER"]
      cert_file = x509_file
      key_file = x509_file
      #cert_file = "#{ENV['HOME']}/.globus/usercert.pem"
      #key_file = "#{ENV['HOME']}/.globus/userkey.pem"
      curl.cacert = "#{ENV['HOME']}/.globus/certificates/gd-bundle_ca.cert"
      curl.cert = cert_file
      curl.cert_key = key_file

      curl.verbose = true

      curl.perform
      assert_equal "tasksummary", JSON.parse(res.body)['DATA_TYPE']
    end
  end
end
