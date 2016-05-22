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

# Some example Wikidata API returns to use in tests:

def sample_search_results
  {"searchinfo":{"search":"attila the hun"},"search":[{"id":"Q36724","concepturi":"http://www.wikidata.org/entity/Q36724","url":"//www.wikidata.org/wiki/Q36724","title":"Q36724","pageid":39340,"label":"Attila the Hun","description":"King of the Hunnic Empire","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q17987270","concepturi":"http://www.wikidata.org/entity/Q17987270","url":"//www.wikidata.org/wiki/Q17987270","title":"Q17987270","pageid":19520840,"label":"Attila the Hun","description":"Wikimedia disambiguation page","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q4818461","concepturi":"http://www.wikidata.org/entity/Q4818461","url":"//www.wikidata.org/wiki/Q4818461","title":"Q4818461","pageid":4604573,"label":"Attila the Hun","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q4818464","concepturi":"http://www.wikidata.org/entity/Q4818464","url":"//www.wikidata.org/wiki/Q4818464","title":"Q4818464","pageid":4604576,"label":"Attila the Hun","description":"Calypsonian","match":{"type":"label","language":"en","text":"Attila the Hun"}},{"id":"Q4818462","concepturi":"http://www.wikidata.org/entity/Q4818462","url":"//www.wikidata.org/wiki/Q4818462","title":"Q4818462","pageid":4604574,"label":"Attila the Hun in popular culture","match":{"type":"label","language":"en","text":"Attila the Hun in popular culture"}}],"success":1}
end

def empty_search_results
  {"searchinfo":{"search":"jdsakjdnmasdda"},"search":[],"success":1}
end

def property_search_results
  {"searchinfo":{"search":"gender"},"search":[{"id":"P21","concepturi":"http://www.wikidata.org/entity/P21","url":"//www.wikidata.org/wiki/Property:P21","title":"Property:P21","pageid":3917971,"label":"sex or gender","description":"Sexual identity of subject: male (Q6581097), female (Q6581072), intersex (Q1097630), transgender female (Q1052281),  transgender male (Q2449503). Animals: male animal (Q44148), female animal (Q43445). Groups of same gender use \"subclass of\" (P279)","match":{"type":"alias","language":"en","text":"gender"},"aliases":["gender"]},{"id":"P2433","concepturi":"http://www.wikidata.org/entity/P2433","url":"//www.wikidata.org/wiki/Property:P2433","title":"Property:P2433","pageid":23912901,"label":"gender of a scientific name of a genus","description":"determines the correct form of some names of species and subdivisions of species, also subdivisions of a genus","match":{"type":"label","language":"en","text":"gender of a scientific name of a genus"}}],"success":1}
end

def simple_single_item_results
  {"entities":{"Q332528":{"type":"item","id":"Q332528","labels":{"en":{"language":"en","value":"Winston Spencer-Churchill"}},"descriptions":{"en":{"language":"en","value":"British politician"}},"aliases":{"en":[{"language":"en","value":"Winston Churchill"}]}}},"success":1}
end

def no_such_entity_response
  {"servedby":"mw1193","error":{"code":"no-such-entity","info":"Could not find such an entity. (Invalid id: pop)","id":"pop","messages":[{"name":"wikibase-api-no-such-entity","parameters":[],"html":{"*":"Could not find such an entity."}}],"*":"See https://www.wikidata.org/w/api.php for API usage"}}
end