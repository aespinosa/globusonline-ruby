require 'globusonline'
require 'test/unit'
require 'json'

class ApiTest < Test::Unit::TestCase

  def test_cookie_or_cerficate_exclusivity
    exp = assert_raise RuntimeError do
      api = GlobusOnline::API.new(:user => "someuser",
                                  cert_file: "somefile.pem",
                                  saml_cookie: "cookiestring")
    end
    assert_match /pass either cookie or cert\/key not both/, exp.message

    assert_nothing_raised RuntimeError do
      begin
        api = GlobusOnline::API.new(:user => "someuser",
                                    saml_cookie: "cookiestring")
        api = GlobusOnline::API.new(:user => "someuser",
                                    cert_file: "somefile.pem")
      rescue TypeError
      end
    end
  end

  def test_saml_cookie
    # Obtain a cookie using
    # $ curl --data "username=USERNAME&password=PASSWORD" -v \
    #   https://www.globusonline.org/authenticate
    # Look for the "saml=" string at the response and export it to your shell as
    # the GLOBUSONLINE_COOKIE environment variable
    skip "No cookie defined" if not ENV['GLOBUSONLINE_COOKIE']
    api = GlobusOnline::API.new(:user => ENV["USER"],
                                saml_cookie: ENV['GLOBUSONLINE_COOKIE'])
    res = api["/tasksummary"].get
    assert_equal "tasksummary", JSON.parse(res)["DATA_TYPE"]
  end

  def test_x509_test
    cert_file = "#{ENV["HOME"]}/.globus/usercert.pem"
    key_file = "#{ENV["HOME"]}/.globus/userkey.pem"
    skip "No globus user certificates found" if not File.exists? cert_file
    skip "No globus private keys found" if not File.exists? cert_file
    ca_file = "#{ENV["HOME"]}/.globus/certificates/gd-bundle_ca.cert"
    api = GlobusOnline::API.new(:user => ENV["USER"], cert_file: cert_file,
                                key_file: key_file, ca_file: ca_file)
    res = api["/tasksummary"].get
    assert_equal "tasksummary", JSON.parse(res)["DATA_TYPE"]
  end

  def test_using_metaprogramming_method
    cert_file = "#{ENV["HOME"]}/.globus/usercert.pem"
    key_file = "#{ENV["HOME"]}/.globus/userkey.pem"
    skip "No globus user certificates found" if not File.exists? cert_file
    skip "No globus private keys found" if not File.exists? cert_file
    ca_file = "#{ENV["HOME"]}/.globus/certificates/gd-bundle_ca.cert"
    api = GlobusOnline::API.new(:user => ENV["USER"], cert_file: cert_file,
                                key_file: key_file, ca_file: ca_file)
    res = api.tasksummary
    assert_equal "tasksummary", JSON.parse(res)["DATA_TYPE"]
  end
end

