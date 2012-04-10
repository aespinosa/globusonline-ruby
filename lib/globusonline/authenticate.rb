require 'highline'

module GlobusOnline
  module Authenticate
    URL = "https://www.globusonline.org/authenticate"
    def self.saml(options = {})
      url = options[:url] || URL
      hl = HighLine.new($stdin, $stderr)
      username = options[:username] || ENV["USER"]
      password = options[:password] || hl.ask("Password: ") {|x| x.echo = "*"}

      resp = RestClient.post(url,
                             username: username,
                             password: password) { |resp| resp }
      resp.cookies["saml"]
    end
  end
end
