module GimmeWikidata

  ##
  # Models a parsed response from a get entities query to the Wikidata API
  class EntityResult

    attr_reader :success, :error, :entities

    def initialize(success, error)
      @error = error
      @success = @error.nil? ? (success == 1) : false
      @entities = []
    end

  end

end