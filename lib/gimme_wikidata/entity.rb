module GimmeWikidata

  class Entity

    @id
    @label
    @description
    @aliases

    attr_reader :id, :label, :description, :aliases

    def initialize(id, label, description, aliases)
      @id = id
      @label = label
      @description = description
      @aliases = aliases
    end

  end

end