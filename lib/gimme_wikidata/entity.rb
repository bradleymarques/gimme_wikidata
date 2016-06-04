module GimmeWikidata

  ##
  # Models an Entity on Wikidata.
  #
  # An Entity is suclassed into Item and Property.
  #
  # An Entity has to have a valid Wikidata id, but the other class data is optional
  #
  # See: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries
  class Entity

    ##
    # The Wikidata id of the Entity in the form 'PN' or 'QN' where 'P' means Property and 'Q' means Item.  N can be any positive integer.
    attr_reader :id
    ##
    # The Entity's label (in the language specified by WikidataAPI).  Can be nil in the case of an unresolved Entity.
    attr_accessor :label
    ##
    # The Entity's description (in the language specified by WikidataAPI).  Can be nil in the case of an unresolved Entity.
    attr_accessor :description
    ##
    # The Entity's aliases (in the language specified by WikidataAPI).  Can be an empty array in the case of an unresolved Entity.
    attr_accessor :aliases
    ##
    # Each Entity has a number of claims, stored as an array of Claim objects.
    attr_accessor :claims

    def initialize(id, label = nil, description = nil, aliases = nil, claims = [])
      throw ArgumentError.new 'Invalid Wikidata id' unless GimmeWikidata.valid_id? id
      @id = id
      @label = label
      @description = description
      @aliases = aliases
      @claims = claims
      @claims = [] if @claims.nil?
    end

    ##
    # Does this Entity have a fingerprint (an +id+, +title+ and +description+)
    #
    # Returns:
    # - boolean
    def has_fingerprint?
      !(@id.nil? || @label.nil? || @description.nil?)
    end

    ##
    # Does this Entity have any claims?
    #
    # Returns:
    # - boolean
    def has_claims?
      !(@claims.empty?)
    end

    ##
    # Get all the Claims which have Properties with the passed id
    def claims_with_property_id(id)
      raise ArgumentError.new 'Invaild Wikidata Id' unless GimmeWikidata.valid_id? id
      claims = []
      @claims.each do |c|
        claims << c if c.property.id == id
      end
      claims
    end

    ##
    # Get more data on an Entity's Properties
    #
    # Entities have Properties (through Claims), which are by default only returned as ids.  This function gets more details for each of these.
    #
    # * *Parameters:*
    #   - +props+ -> The Props to fetch.  Defaults to +Props::LABELS+.
    # * *Returns:*
    #   - +nil+
    # * *Raises:*
    #   - +StandardError+ -> if there was an error in fetching the data
    def resolve_properties(props = [Props::LABELS])
      return nil unless has_claims?
      unique_property_ids = (claims.map {|c| c.property.id}).uniq
      # Get only the labels for the Entity's Properties from the Wikidata API
      response = GimmeWikidata::fetch(unique_property_ids, props: [Props::LABELS])
      raise StandardError.new "Could not resolve Entity (#{@id} - #{@label}) properties" unless response.was_successful?
      response.entities.each do |property_details|
        claims = claims_with_property_id(property_details.id)
        claims.map {|c| c.property.resolve_with(property_details)}
      end
      return nil
    end

    ##
    # Resolves the Claims that refer to Entities
    #
    # Claims often refer to another entity on Wikidata.  By default, we will only know the ids of these with one fetch Entity call.  This therefore gets more data regarding these.
    #
    # * *Parameters:*
    #   - +props+ -> The Props to fetch.  Defaults to +Props::LABELS+
    def resolve_claims(props = [Props::LABELS])
      return unless has_claims?
      item_claims = get_claims_by_value_type(:item)
      item_ids = item_claims.map {|c| c.value.id }
      entity_result = GimmeWikidata.fetch(item_ids, props: props)
      entity_result.entities.each do |item_details|
        item_index = item_ids.index(item_details.id)
        item_to_resolve = item_claims[item_index].value
        item_to_resolve.resolve_with(item_details)
      end
    end

    ##
    # Get all Claims that have a specific +value_type+ symbol
    #
    # * *Parameters:*
    #   - +type+ -> Symbol value of the Claim's +value_type+ attribute
    # * *Returns:*
    #   - An Array of Claims
    def get_claims_by_value_type(type)
      return [] unless has_claims?
      claims = []
      @claims.each do |c|
        claims << c if c.value_type == type.to_sym
      end
      return claims
    end

    ##
    # Returns a simplified version of an Entity's Claims
    # * *Returns:*
    #   - Array of hashes representing simplified Claims.  See Claim.simplify()
    def simple_claims
      claims.map {|c| c.simplify }
    end

    ##
    # Resolves an incomplete Entity with additional details
    #
    # * *Parameters:*
    #   - +entity_details+ -> Either an Item or an Property
    # * *Returns:*
    # * *Raises:*
    #   - +ArgumentError+ -> if attempting to resolve an Item with a Property, or a Property with an Item
    #   - +StandardError+ -> if attempting to resolve an Entity with details that have unequal ids
    def resolve_with(entity_details)
      raise ArgumentError.new "Attempting to resolve an Item with a Property or vice versa" if entity_details.id[0] != @id[0]
      raise StandardError.new "Attempting to resolve Entity with id #{@id} with entity_details with id #{entity_details.id}" unless @id == entity_details.id
      #TODO: Wouldn't it be easier to simply overwrite the Entity? (self = entity_details?)
      @label = entity_details.label
      @description = entity_details.description
      @aliases = entity_details.aliases
      @claims = entity_details.claims
      @claims = [] if @claims.nil?
    end

  end

end