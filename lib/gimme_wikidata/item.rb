module GimmeWikidata

  class Item

    @id             = 0
    @label          = ''
    @description    = ''
    @aliases        = []
    @claims         = []

    def initialise(id)
      @id = id
    end

  end

end