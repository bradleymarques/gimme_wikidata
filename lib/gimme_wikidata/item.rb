require 'gimme_wikidata/entity'

module GimmeWikidata

  ##
  # An ItemStub is a placeholder for an Item; essentially, it an Item without any claims, but with an id, label, description and aliases.
  #
  # This concept does not exist on Wikidata, but is used here to serve as a placeholder for an item without the need to get its claims.
  class ItemStub < Entity

  end

  ##
  # Models an Item on Wikidata, which is a "real-world object, concept, event"
  #
  # Please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries for more details
  class Item < ItemStub

  end

end