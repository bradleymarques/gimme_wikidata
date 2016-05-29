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
    # TODO: IMPLEMENT AND DOCUMENT!
    def resolve_properties
      return unless has_claims?
      puts "resolving properties for item #{id} - #{label}"
    end

    ##
    # TODO: IMPLEMENT AND DOCUMENT!
    def resolve_claims
      return unless has_claims?
      puts "resolving claims for item #{id} - #{label}"
    end

  end

end