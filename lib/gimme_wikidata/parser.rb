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
      label = e.fetch(:labels, {}).fetch(lang, {}).fetch(:value, nil)
      description = e.fetch(:descriptions, {}).fetch(lang, {}).fetch(:value, nil)
      # Parse aliases, if any:
      aliases_hash = e.fetch(:aliases, {}).fetch(lang, nil)
      aliases = aliases_hash.nil? ? [] :aliases_hash.map { |a| a.fetch(:value, nil) }
      # Parse claims, if any
      claims = e.fetch(:claims, nil).nil? ? [] : parse_claims(e.fetch(:claims, nil))
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
      raw_value = s.fetch(:datavalue, {}).fetch(:value, nil)

      #TODO: Figure out why raw_value has some strange keys
      #TODO: Correct for the very strange keys in raw_value

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

    ##
    # TODO: DOCUMENT FULLY
    #
    # A List of all Wikidata datatypes: https://www.wikidata.org/wiki/Special:ListDatatypes
    def self.parse_snak_wikibase_item(raw_value)
      id = raw_value.fetch(:"numeric-id", nil)
      type = raw_value.fetch(:"entity-type", nil)
      case type
      when 'item'
        return Item.new("Q#{id}"), :item
      when 'property'
        return Property.new("P#{id}"), :property
      else
        raise StandardError.new "Unknown wikibase item type #{raw_value[:entity_type]}"
      end
    end

    def self.parse_snak_external_id(raw_value)
      #TODO: Extract the authoritative source
      return raw_value, :external_id
    end

    ##
    # Parses a Wikidata Time value
    #
    # Times on Wikidata are stored as timestamp resembling ISO 8601
    def self.parse_snak_time(raw_value)
      #timestamp = raw_value[:time]
      #precision = raw_value[:precision]
      # TODO: Format this into a Ruby DateTime object
      # TODO: Figure out how to store variable-precision dates
      return raw_value, :wikidata_time
    end

    def self.parse_snak_commons_media(raw_value)
      return raw_value, :media
    end

    def self.parse_snak_monolingual_text(raw_value)
      return raw_value.fetch(:text, nil), :text
    end

    def self.parse_snak_string(raw_value)
      return raw_value, :text
    end

    def self.parse_snak_url(raw_value)
      return raw_value, :url
    end

    def self.parse_snak_gps_coordinate(raw_value)
      return {latitude: raw_value[:latitude], longitude: raw_value[:longitude]}, :gps_coordinates
    end

    def self.parse_snak_quantity(raw_value)
      quantity = {amount: raw_value[:amount], upper_bound: raw_value[:upperBound], lower_bound: raw_value[:lower_bound]}
      return quantity, :quantity
    end

  end

end