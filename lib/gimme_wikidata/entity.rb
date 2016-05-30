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

    attr_reader :id
    attr_accessor :label, :description, :aliases, :claims

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
    # Does this Entity have a fingerprint (id, title and description)
    def has_fingerprint?
      !(@id.nil? || @label.nil? || @description.nil?)
    end

    ##
    # Does this Entity have any claims?
    def has_claims?
      !(@claims.empty?)
    end

    ##
    # Get all the Claims which have Properties with the passed id
    def claims_with_property_id(id)
      raise ArgumentError.new 'Invalid Wikidata Id' unless GimmeWikidata.valid_id? id
      claims = []
      @claims.each do |c|
        claims << c if c.property.id == id
      end
      claims
    end

    ##
    # TODO: IMPLEMENT AND DOCUMENT!
    def resolve_properties
      return unless has_claims?
      unique_property_ids = (claims.map {|c| c.property.id}).uniq
      # Get only the labels for the Entity's Properties from the Wikidata API
      response = GimmeWikidata::fetch(unique_property_ids, props: [Props::LABELS])
      raise StandardError.new "Could not resolve Entity (#{@id} - #{@label}) properties" unless response.was_successful?
      response.entities.each do |property_details|
        claims = claims_with_property_id(property_details.id)
        claims.map {|c| c.property.resolve_with(property_details)}
      end
    end

    ##
    # TODO: IMPLEMENT AND DOCUMENT!
    def resolve_claims
      return unless has_claims?
      item_claims = get_claims_by_value_type(:item)
      item_ids = item_claims.map {|c| c.value.id }
      entity_result = GimmeWikidata.fetch(item_ids, props: [Props::LABELS])
      entity_result.entities.each do |item_details|
        item_index = item_ids.index(item_details.id)
        item_to_resolve = item_claims[item_index].value
        item_to_resolve.resolve_with(item_details)
      end
    end

    ##
    # TODO: DOCUMENT
    def get_claims_by_value_type(type)
      return [] unless has_claims?
      claims = []
      @claims.each do |c|
        claims << c if c.value_type == type
      end
      return claims
    end

    ##
    # Returns a simple hash of claims and their values
    #
    def simple_claims
      simple = claims.map {|c| c.simplify }
      simple.merge_hashes
    end

    ##
    # TODO: DOCUMENT
    def resolve_with(entity_details)
      raise ArgumentError.new "Attempting to resolve an Item with a Property or vice versa" if entity_details.id[0] != @id[0]
      raise StandardError.new "Attempting to resolve Entity with id #{@id} with entity_details with id #{entity_details.id}" unless @id == entity_details.id
      @label = entity_details.label
      @description = entity_details.description
      @aliases = entity_details.aliases
      @claims = entity_details.claims
      @claims = [] if @claims.nil?
    end

    ##
    # Prints a pretty version of the Entity
    def print(colour = :blue)
      puts "#{label} (#{id})".bold.colorize(background: colour)
      puts description.colorize(color: colour)
      puts "Aliases: " + @aliases.join(', ')
      puts "Claims:".underline
      simple_claims.each do |label, value|
        puts "\t#{label}: ".bold.colorize(color: colour) + "#{value}"
      end
      return nil
    end

  end

end