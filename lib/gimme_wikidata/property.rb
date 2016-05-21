module GimmeWikidata

  ##
  # Models a Property on Wikidata.  Properties have a title, description and aliases.
  #
  # On Wikidata, Properties have other properties as well, but this is not catered for (yet)
  class Property < Entity

    def wikidata_id
      "P#{@id}"
    end

    def initialize(id)
      @id = id
    end

  end

end