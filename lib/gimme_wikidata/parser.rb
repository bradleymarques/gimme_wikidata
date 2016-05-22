require 'gimme_wikidata/wikidata_api'

module GimmeWikidata

  ##
  # Responsible for parsing the JSON data from the Wikidata API
  #
  class Parser

    ##
    # Parses the results from a search query
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
    # Parses the results from a get entities query
    def self.parse_entity_response(response)
      entity_result = EntityResult.new(response[:success], response[:error])
      response[:entities].each do |key, value|
        entity_result.entities << parse_entity(value)
      end
      return entity_result
    end

    def self.parse_entity(e)
      puts e
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