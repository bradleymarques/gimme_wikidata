module GimmeWikidata

  ##
  # Models a parsed response from a get entities query to the Wikidata API
  class EntityResult

    attr_reader :success, :error, :entities

    def initialize(success, error = nil, entities = [])
      @error = error
      @success = @error.nil? ? (success == 1) : false
      @entities = entities
    end

    def was_successful?
      @success
    end

    def empty?
      @entities.empty?
    end

    ##
    # TODO: DOCUMENT!
    def resolve_all_properties
      return false if empty?
      entities.each {|e| e.resolve_properties }
      return true
    end

    ##
    # TODO: DOCUMENT!
    def resolve_all_claims
      return false if empty?
      entities.each {|e| e.resolve_claims }
      return true
    end

  end

end