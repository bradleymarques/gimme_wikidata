module GimmeWikidata

  ##
  # Models an Entity on Wikidata.
  #
  # An Entity is suclassed into Item and Property
  #
  # See: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries
  class Entity

    attr_reader :id, :label, :description, :aliases, :claims

    def initialize(id = nil, label = nil, description = nil, aliases = [], claims = [])
      @id = id
      @label = label
      @description = description
      @aliases = aliases
      @claims = []
    end

  end

end