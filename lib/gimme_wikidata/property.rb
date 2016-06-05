require 'gimme_wikidata/entity'

module GimmeWikidata

  ##
  # Models an Property on Wikidata, which is a kind of Entity
  #
  # Please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries for more details
  class Property < Entity

    def initialize(id, label = nil, description = nil, aliases = nil, claims = [])
      throw ArgumentError.new "Invalid Wikidata Property id: #{id}" unless GimmeWikidata.valid_id?(id, [:property])
      super(id, label, description, aliases, claims)
    end

  end

end