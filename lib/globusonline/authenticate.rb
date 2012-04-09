require 'highline/import'

module GlobusOnline
  module Authenticate
    URL = "https://www.globusonline.org/authenticate"
    def self.saml(options = {})
      url = options[:url] || URL
      username = options[:username] || ENV["USER"]
      password = options[:password] || ask("Password: ") {|x| x.echo = "*"}

      resp = RestClient.post(url,
                             username: username,
                             password: password) { |resp| resp }
      resp.cookies["saml"]
    end
  end
end
