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
      lang = WikidataAPI.get_language.to_sym
      # Parse the fingerprint (id, label and description)
      id = e.fetch(:id, nil)
      label = e.fetch(:labels, nil).fetch(lang, nil).fetch(:value, nil)
      description = e.fetch(:descriptions, nil).fetch(lang, nil).fetch(:value, nil)
      # Parse aliases, if any:
      aliases_hash = e.fetch(:aliases, nil).fetch(lang, nil)
      aliases = aliases_hash.nil? ? [] :aliases_hash.map { |a| a[:value] }
      # Parse claims, if any
      claims = e.fetch(:claims, nil).nil? ? [] : parse_claims(e.fetch(:claims))
      # Create an Item or a Property
      case e.fetch(:type, nil)
      when 'item'
        return Item.new(id, label, description, aliases, claims)
      when 'property'
        return Property.new(id, label, description, aliases, claims)
      else
        return nil
      end
    end

    ##
    # TODO: DOCUMENT
    def self.parse_claims(c)
      claims = []
      c.values.flatten.each do |snak|
        claims << parse_snak(snak[:mainsnak])
      end
      return claims
    end

    ##
    # TODO: DOCUMENT
    def self.parse_snak(s)
      property = Property.new(s[:property])
      raw_value = s[:datavalue][:value]
      value, value_type = case s[:datatype]
      when 'wikibase-item'
        parse_snak_wikibase_item(raw_value)
      when 'external-id'
        parse_snak_external_id(raw_value)
      when 'time'
        parse_snak_time(raw_value)
      when 'commonsMedia'
        parse_snak_commons_media(raw_value)
      when 'monolingualtext'
        parse_snak_monolingual_text(raw_value)
      when 'string'
        parse_snak_string(raw_value)
      when 'url'
        parse_snak_url(raw_value)
      when 'globe-coordinate'
        parse_snak_gps_coordinate(raw_value)
      when 'quantity'
        parse_snak_quantity(raw_value)
      else
        raise NotImplementedError.new "Unsupported snak datatype: #{s[:datatype]}"
      end
      Claim.new(property, value, value_type)
    end


    # Individual Snak Parsing
    def self.parse_snak_wikibase_item(raw_value)
      return 0, Item
    end

    def self.parse_snak_external_id(raw_value)
      return 0, :external_id
    end

    def self.parse_snak_time(raw_value)
      return Time.now, Time
    end

    def self.parse_snak_commons_media(raw_value)
      return 'image-to-go-here.jpg', :media
    end

    def self.parse_snak_monolingual_text(raw_value)
      return 'text-to-go-here', :text
    end

    def self.parse_snak_string(raw_value)
      return 'text-to-go-here', :text
    end

    def self.parse_snak_url(raw_value)
      return 'www.url-to-go-here.com', :url
    end

    def self.parse_snak_gps_coordinate(raw_value)
      return 'GPS TO GO HERE', :url
    end

    def self.parse_snak_quantity(raw_value)
      return 0, :number
    end

  end

end