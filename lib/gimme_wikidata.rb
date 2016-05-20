require 'gimme_wikidata/version'
require 'gimme_wikidata/property'
require 'gimme_wikidata/claim'
require 'gimme_wikidata/snak'
require 'gimme_wikidata/item'

module GimmeWikidata
  class << self

    Language    = 'en' # The language with which to query the Wikidata API
    Api_Url     = 'https://www.wikidata.org/w/api.php?'
    Data_Format = 'json'

  end
end
