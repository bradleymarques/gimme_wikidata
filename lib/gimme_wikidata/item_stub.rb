require 'gimme_wikidata/entity'

module GimmeWikidata

  class ItemStub < Entity

    def wikidata_id
      "Q#{@id}"
    end

  end

end