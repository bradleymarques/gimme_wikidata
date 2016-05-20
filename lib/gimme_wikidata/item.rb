module GimmeWikidata

  ##
  # Models an Item on Wikidata.
  class Item

    @id             = 0  # Integer id of the Item, corresponding to the URI on wikidata.  Appended with a 'Q' when interfacing with the API
    @label          = '' # String label of the Item, for example, 'Attila the Hun'
    @description    = '' # String description of the Item in the default language
    @aliases        = [] # Array of Strings that are aliases for the Item
    @claims         = [] # Array of Claim objects that are recorded for the Item on Wikidata

    def initialise(id)
      @id = id
    end

  end

end