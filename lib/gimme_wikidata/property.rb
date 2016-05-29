require 'gimme_wikidata/entity'

module GimmeWikidata

  ##
  # Models an Property on Wikidata, which is a kind of Entity
  #
  # Please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Entities.2C_items.2C_properties_and_queries for more details
  class Property < Entity

    ##
    # TODO: DOCUMENT
    def resolve_with(property_details)
      raise StandardError.new "Attempting to resolve Property with id #{@id} with propery details with id #{property_details.id}" unless @id == property_details.id
      @label = property_details.label
      @description = property_details.description
      @aliases = property_details.aliases
      @claims = property_details.claims
      @claims = [] if @claims.nil?
    end

  end

end