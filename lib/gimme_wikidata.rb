require 'gimme_wikidata/claim'
require 'gimme_wikidata/entity'
require 'gimme_wikidata/entity_result'
require 'gimme_wikidata/extensions'
require 'gimme_wikidata/enums'
require 'gimme_wikidata/item'
require 'gimme_wikidata/parser'
require 'gimme_wikidata/property'
require 'gimme_wikidata/search'
require 'gimme_wikidata/snak'
require 'gimme_wikidata/version'
require 'gimme_wikidata/wikidata_api'

module GimmeWikidata

  include SymbolizeHelper

  class << self

    def search(search_term)
      search_query = WikidataAPI.search_query(search: search_term)
      response = WikidataAPI.make_call(search_query)
      Parser.parse_search_response(response)
    end

    def fetch(ids)
      get_query = WikidataAPI.get_entities_query(ids: ids)
      response = WikidataAPI.make_call(get_query)
      Parser.parse_entity_response(response)
    end

  end

end
