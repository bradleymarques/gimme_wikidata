$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gimme_wikidata'

require 'minitest'
require 'minitest/autorun'
require 'minitest/display'
require 'minitest/reporters'

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

Minitest::Reporters.use! [ Minitest::Reporters::SpecReporter.new(color: true) ]
#Minitest::Reporters.use! [ Minitest::Reporters::ProgressReporter.new(color: true) ]
#Minitest::Reporters.use! [ Minitest::Reporters::HtmlReporter.new ]

def sample_search_results
  J{"searchinfo":{"search":"attila the hun"},"search":[{"id":"Q36724","concepturi":"http://www.wikidata.org/entity/Q36724","url":"//www.wikidata.org/wiki/Q36724","title":"Q36724","pageid":39340,"label":"Attila the Hun","description":"King of the Hunnic Empire","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q17987270","concepturi":"http://www.wikidata.org/entity/Q17987270","url":"//www.wikidata.org/wiki/Q17987270","title":"Q17987270","pageid":19520840,"label":"Attila the Hun","description":"Wikimedia disambiguation page","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q4818461","concepturi":"http://www.wikidata.org/entity/Q4818461","url":"//www.wikidata.org/wiki/Q4818461","title":"Q4818461","pageid":4604573,"label":"Attila the Hun","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q4818464","concepturi":"http://www.wikidata.org/entity/Q4818464","url":"//www.wikidata.org/wiki/Q4818464","title":"Q4818464","pageid":4604576,"label":"Attila the Hun","description":"Calypsonian","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q4818462","concepturi":"http://www.wikidata.org/entity/Q4818462","url":"//www.wikidata.org/wiki/Q4818462","title":"Q4818462","pageid":4604574,"label":"Attila the Hun in popular culture","match":{"type":"label","language":"en","text":"Attila the Hun in popular culture"}}],"success":1}
end


