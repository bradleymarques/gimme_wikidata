require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gimme_wikidata'

require 'minitest'
require 'minitest/autorun'
require 'minitest/display'
require 'minitest/reporters'

require "#{File.join(Dir.pwd, 'test', 'test_api_results', 'response_faker')}"

MiniTest::Display.options = {
  suite_names: true,
  :suite_divider => '|',
  color: true,
  print: {
    success:    "PASS\n",
    failure:    "FAIL\n",
    error:      "ERROR\n"
  }
}

Minitest::Reporters.use! [ Minitest::Reporters::SpecReporter.new(color: true), Minitest::Reporters::HtmlReporter.new ]

