$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gimme_wikidata'

require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/display'

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

Minitest::Reporters.use! [ Minitest::Reporters::ProgressReporter.new(color: true) ]
