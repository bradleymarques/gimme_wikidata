require 'gimme_wikidata/entity'

module GimmeWikidata

  class Property < Entity

    def wikidata_id
      "P#{@id}"
    end

  end

end