require 'gimme_wikidata/wikidata_api'
require 'carbon_date'

module GimmeWikidata

  ##
  # Responsible for parsing the JSON data returned from the Wikidata API.
  #
  #
  # Parses responses to the following Wikidata API calls:
  # - +wbsearchentities+
  # - +wbgetentities+
  class Parser

    include CarbonDate

    ##
    # Parses the results from a search query (wbsearchentities)
    # * *Args*    :
    #   - +response+ -> hash form of the response from the Wikidata API
    # * *Returns* :
    #   - A +Search+ object representing and containing the +SearchResults+ found
    # Returns a Search object representing a collection of the SearchResults found
    def self.parse_search_response(response)
      search = Search.new(
        response.fetch(:success, false),
        response.fetch(:error, nil),
        response.fetch(:searchinfo, {}).fetch(:search, nil))
      return search unless search.was_successful?
      raise ArgumentError, 'response did not seem to be a response from a search query' if response[:searchinfo].nil?
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
      entity_result = EntityResult.new(response.fetch(:success, false), response.fetch(:error, nil))
      return entity_result unless entity_result.was_successful?
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
    #
    # A List of all Wikidata datatypes: https://www.wikidata.org/wiki/Special:ListDatatypes
    def self.parse_snak(s)
      property = Property.new(s[:property])
      raw_value = s.fetch(:datavalue, {}).fetch(:value, nil)

      #TODO: Figure out why raw_value has some strange keys. Example => ':"key"'
      #TODO: Correct for the very strange keys in raw_value

      ##
      # TODO: Use meta-programming and public_send() to DRY this code up:
      value, value_type =
      case s[:datatype]
      when 'wikibase-item' then parse_snak_wikibase_item(raw_value)
      when 'external-id' then parse_snak_external_id(raw_value)
      when 'time' then parse_snak_time(raw_value)
      when 'commonsMedia' then parse_snak_commons_media(raw_value)
      when 'monolingualtext' then parse_snak_monolingual_text(raw_value)
      when 'string' then parse_snak_string(raw_value)
      when 'url' then parse_snak_url(raw_value)
      when 'globe-coordinate' then parse_snak_gps_coordinate(raw_value)
      when 'quantity' then parse_snak_quantity(raw_value)
      when 'math' then parse_snak_math(raw_value)
      else
        raise StandardError.new "Unsupported Wikidata snak datatype: #{s[:datatype]}"
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
        raise StandardError.new "Unknown Wikibase item type #{raw_value[:entity_type]}"
      end
    end

    def self.parse_snak_external_id(raw_value)
      #TODO: Extract the authoritative source
      return raw_value, :external_id
    end

    ##
    # Parses a Wikidata Time value
    #
    # Times on Wikidata are stored as timestamp in the ISO8601 standard.  Use the CarbonDate gem (https://github.com/bradleymarques/carbon_date) to interpret these
    #
    # Params:
    # - +raw_value+: a hash with the keys:
    #   - +:time+: The time in the ISO8601 standard
    #   - +:timezone+: currently unused
    #   - +:before+: currently unused
    #   - +:after+: currently unused
    #   - +:precision+: an integer value (0..14)
    #   - +:calendarmodel+: currently unused
    #
    # Example +raw_value+:
    # {"time": "+1940-10-10T00:00:00Z", "timezone": 0, "before": 0, "after": 0, "precision": 11, "calendarmodel": "http://www.wikidata.org/entity/Q1985727"}
    #
    # Returns:
    # - [CarbonDate::Date object, :carbon_date]
    def self.parse_snak_time(raw_value)
      time = raw_value.fetch(:time, nil)
      precision = raw_value.fetch(:precision, nil)
      return CarbonDate.from_iso8601(time, precision), :carbon_date
    end

    def self.parse_snak_commons_media(raw_value)
      file_name = raw_value.to_s.gsub(' ', '_')
      full_url = "https://commons.wikimedia.org/wiki/File:" + file_name
      return full_url, :media
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
      quantity = {
        amount: raw_value.fetch(:amount, 0).to_f,
        upper_bound: raw_value.fetch(:upperBound, 0).to_f,
        lower_bound: raw_value.fetch(:lowerBound, 0).to_f,
        unit: raw_value.fetch(:unit, 0).to_f
      }
      return quantity, :quantity
    end

    def self.parse_snak_math(raw_value)
      return raw_value, :math
    end

  end

end