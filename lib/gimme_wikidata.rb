require 'gimme_wikidata/claim'
require 'gimme_wikidata/entity'
require 'gimme_wikidata/entity_result'
require 'gimme_wikidata/extensions'
require 'gimme_wikidata/enums'
require 'gimme_wikidata/item'
require 'gimme_wikidata/parser'
require 'gimme_wikidata/printer'
require 'gimme_wikidata/property'
require 'gimme_wikidata/search'
require 'gimme_wikidata/version'
require 'gimme_wikidata/wikidata_api'

module GimmeWikidata

  include SymbolizeHelper

  class << self

    ##
    # Search Wikidata for a particular search term, and get the results.
    #
    # Searches the Wikidata API for a particular term and returns some SearchResults (wrapped in a Search object).
    # Constructs the required search query, makes the call to the API and parses the response.
    #
    # * *Parameters*    :
    #   - +search_term+ -> the search term to look for on Wikidata
    #   - +strict_language+ -> Should we force a restriction to the current language?  See WikidataAPI::language
    #   - +type+ -> Either search for 'item' or 'property'.  Defaults to 'item'
    #   - +limit+ -> The maximum number of SearchResults to return.  Defaults to 50.
    #   - +continue+ -> Where to continue the search from.  Defaults to 0.
    # * *Returns* :
    #   - A Search object representing and containing the +SearchResults+ found
    def search(search_term, strict_language: false, type: 'item', limit: 50, continue: 0)
      search_query = WikidataAPI.search_query(search: search_term, strict_language: strict_language, type: type, limit: limit, continue: continue)
      response = WikidataAPI.make_call(search_query)
      Parser.parse_search_response(response)
    end

    ##
    # Fetch Entity (or Entities) from Wikidata by id (or ids)
    #
    # Calls either +fetch_entity+ or +fetch_entities+, so is just for convenience.
    #
    # * *Parameters*    :
    #   - +ids+ -> Either a single Wikidata id or an array of them.  If the former, will call +fetch_entity+; if the latter, will call +fetch_entities+
    #   - +props+ -> The properties to pull from Wikidata (see Props class).  Defaults to +aliases+, +labels+, +descriptions+ and +claims+.
    # * *Returns* :
    #   - An Entity in the case of a single id, and an EntityResult in the case of multiple ids
    # * *Raises* :
    #   - +ArgumentError+ if ids are not valid Wikidata ids
    def fetch(ids, props: [Props::ALIASES, Props::LABELS, Props::DESCRIPTIONS, Props::CLAIMS])
      raise ArgumentError.new 'Invalid Wikidata ids' unless valid_ids? ids
      return fetch_entity(ids, props: props) if ids.is_a? String
      return fetch_entities(ids, props: props) if ids.is_a? Array
    end

    ##
    # Fetch a single Entity from Wikidata by id
    #
    # * *Parameters*    :
    #   - +id+ -> The Wikidata id of the Entity to get
    #   - +props+ -> The properties to pull from Wikidata (see Props class)
    # * *Returns* :
    #   - An Entity if successful, and an EntityResponse (with error message) if unsuccessful
    # * *Raises* :
    #   - +ArgumentError+ if ids are not valid Wikidata ids
    def fetch_entity(id, props: [Props::ALIASES, Props::LABELS, Props::DESCRIPTIONS, Props::CLAIMS])
      raise ArgumentError.new 'Invalid Wikidata ids' unless valid_ids? ids
      entity_result = fetch_entities([id], props: props)
      return entity_result unless entity_result.was_successful?
      entity_result.entities.first # Simply return the first element, since there was only 1 Entity to fetch
    end

    ##
    # Fetch multiple Entities from Wikidata by id
    #
    # Makes a call to Wikidata and get the results wrapped in a +EntityResult+ object
    # * *Parameters*    :
    #   - +ids+ -> An array of Wikidata ids, such as ['Q1', 'Q2', 'P206', 'P16']
    #   - +props+ -> The properties to pull from Wikidata (see Props class)
    # * *Returns* :
    #   - An EntityResult object containing Entities
    # * *Raises* :
    #   - +ArgumentError+ if ids are not valid Wikidata ids
    def fetch_entities(ids, props: [Props::ALIASES, Props::LABELS, Props::DESCRIPTIONS, Props::CLAIMS])
      raise ArgumentError.new 'Invalid Wikidata ids' unless valid_ids? ids
      get_query = WikidataAPI.get_entities_query(ids: ids, props: props)
      response = WikidataAPI.make_call(get_query)
      entity_result = Parser.parse_entity_response(response)
      entity_result.resolve_all_properties
      entity_result.resolve_all_claims if props.include? Props::CLAIMS
      return entity_result
    end

    ##
    # Valdiates an array of ids against Wikidata format
    #
    # Wikidata has ids in the form 'QN' or 'PN' where Q means 'Item', P means 'Property', and N is any number.
    # * *Parameters*:
    #   - +ids+ -> An array of (possible) Wikidata ids to be validated, in string form
    # * *Returns*:
    #   - boolean
    def valid_ids?(ids)
      return ids.all?(&:valid_id?)
    end

    ##
    # Valdiates a single id against Wikidata format
    #
    # Wikidata has ids in the form 'QN' or 'PN' where Q means 'Item', P means 'Property', and N is any number.
    # * *Parameters*    :
    #   - +id+ -> A (possible) Wikidata id to be validated, as a String
    # * *Returns*:
    #   - boolean
    def valid_id?(id)
      return false unless id.is_a? String
      !(/\A[QP][0-9]+\z/.match(id).nil?)
    end

  end

end
