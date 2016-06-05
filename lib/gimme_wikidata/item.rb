require 'gimme_wikidata/entity'

module GimmeWikidata

  ##
  # Models an Item on Wikidata, which is a "real-world object, concept, event"
  #
  # Please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries for more details
  class Item < Entity

    def initialize(id, label = nil, description = nil, aliases = nil, claims = [])
      throw ArgumentError.new "Invalid Wikidata Item id: #{id}" unless GimmeWikidata.valid_id?(id, [:item])
      super(id, label, description, aliases, claims)
    end

  end

end