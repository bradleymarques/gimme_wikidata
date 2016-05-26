require 'gimme_wikidata/wikidata_api'

module GimmeWikidata

  ##
  # Responsible for parsing the JSON data returned from the Wikidata API.
  #
  #
  # Parses responses to the following Wikidata API calls:
  # - +wbsearchentities+
  # - +wbgetentities+
  class Parser

    ##
    # Parses the results from a search query (wbsearchentities)
    # * *Args*    :
    #   - +response+ -> hash form of the response from the Wikidata API
    # * *Returns* :
    #   - A +Search+ object representing and containing the +SearchResults+ found
    # Returns a Search object representing a collection of the SearchResults found
    def self.parse_search_response(response)
      return ArgumentError, 'response did not seem to be a response from a search query' if response[:searchinfo].nil?
      search = Search.new(response[:success], response[:searchinfo][:search])
      return search unless search.was_successful?
      response[:search].each do |r|
        search.results << SearchResult.new(r[:id], r[:label], r[:description])
      end
      return search
    end

    ##
    # Parses the results from a get entities query (wbgetentities)
    #
    # * *Args*    :
    #   - +response+ -> hash form of the response from the Wikidata API
    # * *Returns* :
    #   - A +EntityResult+ object representing the +Entites+ fetched
    def self.parse_entity_response(response)
      entity_result = EntityResult.new(response[:success], response[:error])
      response[:entities].each do |key, value|
        entity_result.entities << parse_entity(value)
      end
      return entity_result
    end

    ##
    # Parses a single entity as part of a get entities query (wbgetentities)
    #
    # * *Args*    :
    #   - +e+ -> hash form of entity from the Wikidata API
    # * *Returns* :
    #   - Either an +Item+ object or a +Property+ object representing the passed +Entity+
    def self.parse_entity(e)
      id = e[:id]
      label = e[:labels][WikidataAPI.get_language.to_sym][:value]
      description = e[:descriptions][WikidataAPI.get_language.to_sym][:value]
      aliases = e[:aliases][WikidataAPI.get_language.to_sym].map { |a| a[:value] }

      case e[:type]
      when 'item'
        entity = Item.new(id, label, description, aliases)
      when 'property'
        entity = Property.new(id, label, description, aliases)
      end

      # TODO: Extract sub-properties

      return entity
    end

  end

end