# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gimme_wikidata/version'

Gem::Specification.new do |spec|
  spec.name          = "gimme_wikidata"
  spec.version       = GimmeWikidata::VERSION
  spec.authors       = ["Bradley Marques"]
  spec.email         = ["bradmarxmoosepi@gmail.com"]

  spec.summary       = %q{Search and fetch data from Wikidata}
  spec.description   = %q{GimmeWikidata is a Ruby gem that provides an interface to search, pull and publish data from Wikidata.  It provides a number of classes that encapsualte the concept model of Wikidata.}
  spec.homepage      = "https://github.com/bradleymarques/gimme_wikidata"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '>= 11.1.2', '~> 11.1.2'
  spec.add_development_dependency 'simplecov', '~> 0.11.2', '>= 0.11.2'
  spec.add_development_dependency 'minitest-display', '>= 0.3.1', '~> 0.3.1'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1.9', '>= 1.1.9'
  spec.add_development_dependency 'm', '>= 1.5.0', '~> 1.5.0'
  spec.add_development_dependency 'pry', '~> 0.10.3', '>= 0.10.3'
  spec.add_development_dependency 'rdoc', '~> 4.2.2', '>= 4.2.2'
  spec.add_development_dependency 'mocha', '~> 1.1.0', '>= 1.1.0'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.add_dependency 'httparty'
  spec.add_dependency 'ruby-enum'
  spec.add_dependency 'colorize'
  spec.add_dependency 'json'
  spec.add_dependency 'carbon_date', '~> 0.1.2', '>= 0.1.2'

end
