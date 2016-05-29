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
    attr_accessor :title, :description, :aliases, :claims

    def initialize(id = nil, label = nil, description = nil, aliases = nil, claims = [])
      throw ArgumentError.new 'Invalid Wikidata id' unless GimmeWikidata.valid_id? id
      @id = id
      @label = label
      @description = description
      @aliases = aliases
      @claims = claims
    end

    ##
    # Does this Entity have a fingerprint (id, title and description)
    def has_fingerprint?
      !(id.nil? || title.nil? || description.nil?)
    end

  end

end