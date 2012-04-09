lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'globusonline/version'

Gem::Specification.new do |s|
  s.name = "globusonline"
  s.version = GlobusOnline::VERSION
  s.authors = ["Allan Espinosa"]
  s.email = ["aespinosa@cs.uchicago.edu"]
  s.summary = "Ruby bindings to the GlobusOnline V0.10 API"
  s.description = "Ruby bindings to the GlobusOnline V0.10 API"

  s.add_dependency "rest-client", "~> 1.6.7"
  s.add_dependency "highline", "~> 1.6.11"
  s.add_development_dependency "curb"
end
