require 'gimme_wikidata/entity'

module GimmeWikidata

  class ItemStub < Entity

  end

  class Item < ItemStub # < Entity
    @claims
  end

end