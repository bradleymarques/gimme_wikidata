require 'gimme_wikidata/entity'

module GimmeWikidata

  ##
  # Models an Item on Wikidata, which is a "real-world object, concept, event"
  #
  # Please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries for more details
  class Item < Entity

    def initialize(id = nil, label = nil, description = nil, aliases = [], claims = [])
      super(id, lable, description, aliases, claims)
    end

    ##
    # TODO: DOCUMENT
    def resolve_claims
      throw NotImplementedError
    end

    ##
    # TODO: DOCUMENT
    def resolve_properties
      throw NotImplementedError
    end

  end

end