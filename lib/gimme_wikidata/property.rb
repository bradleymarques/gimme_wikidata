module GimmeWikidata

  ##
  # Models a Property on Wikidata.  Properties have a title, description and aliases.
  #
  # On Wikidata, Properties have other properties as well, but this is not catered for (yet)
  class Property

    @id             = 0  # Integer id of the Property.  Appended with 'P' when interfacing with the Wikidata API.
    @title          = '' # String title of the Property
    @description    = '' # String description of the Property
    @aliases        = [] # Array of Strings as aliases for the Property

    def initialize(id)
      @id = id
    end

  end

end