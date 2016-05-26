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

    ##
    # Search Wikidata for a particular search term, and get the results.
    # Searches the Wikidata API for a particular term and returns some SearchResults (wrapped in a Search object).
    # Constructs the required search query, makes the call to the API and parses the response.
    # * *Args*    :
    #   - +search_term+ -> the search term to look for on Wikidata
    #   - +strict_language+ -> Should we force a restriction to the current language?  See WikidataAPI::language
    #   - +type+ -> Either search for 'item' or 'property'.  Defaults to 'item'
    #   - +limit+ -> The maximum number of SearchResults to return.  Defaults to 50.
    #   - +continue+ ->
    # * *Returns* :
    #   - A +Search+ object representing and containing the +SearchResults+ found
    def search(search_term, strict_language: false, type: 'item', limit: 50, continue: 0)
      search_query = WikidataAPI.search_query(search: search_term, strict_language: strict_language, type: type, limit: limit, continue: continue)
      response = WikidataAPI.make_call(search_query)
      Parser.parse_search_response(response)
    end

    ##
    # Fetch Entities from Wikidata by id
    # Makes a call to Wikidata and get the results wrapped in a +EntityResult+ object
    # * *Args*    :
    #   - +ids+ -> An array of Wikidata ids, such as ['Q1', 'Q2', 'P206', 'P16']
    # * *Returns* :
    #   - An EntityResult object containing Entities
    def fetch(ids)
      get_query = WikidataAPI.get_entities_query(ids: ids)
      response = WikidataAPI.make_call(get_query)
      Parser.parse_entity_response(response)
    end

    ##
    # Valdiates that the passed array of ids matches Wikidata format
    # Wikidata has ids in the form 'QN' or 'PN' where Q means 'Item', P means 'Property', and N is any number.
    # * *Args*    :
    #   - +ids+ -> An array of (possible) Wikidata ids to be validated
    # * *Returns* :
    #   - boolean
    def valid_ids?(ids)
      return ids.all? { |id| valid_id? id }
    end

    ##
    # Valdiates that a single ids matches Wikidata format
    # Wikidata has ids in the form 'QN' or 'PN' where Q means 'Item', P means 'Property', and N is any number.
    # * *Args*    :
    #   - +id+ -> A (possible) Wikidata ids to be validated
    # * *Returns* :
    #   - boolean
    def valid_id?(id)
      return false unless id.is_a? String
      !(/\A[QP][0-9]+\z/.match(id).nil?)
    end

  end

end
