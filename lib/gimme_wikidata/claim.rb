module GimmeWikidata

  ##
  # Models a Claim on Wikidata, which consists of a Property and a value
  #
  # Note that the value can be of any type (example: a number, a date), and is often another Item on Wikidata.
  #
  # For more details, please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Claims_and_statements
  class Claim

    ##
    # The Property that the Claim is about
    attr_reader :property

    ##
    # The value that the Property is claimed to have
    attr_reader :value

    ##
    # The type of value.  Current types:
    # - item
    # - property
    # - wikidata_time
    # - external_id
    # - media
    # - text
    # - url
    # - gps_coordinates
    # - quantity
    attr_reader :value_type

    def initialize(property = nil, value = nil, value_type = nil)
      @property = property
      @value = value
      @value_type = value_type
    end

    ##
    # Returns a simple hash form of the claim.
    #
    # Example: {sex_or_gender: "Male"}
    def simplify
      property = @property.label
      value = simplify_value
      return {property: property, value: value}
    end

    ##
    # Simplifies the value
    #
    # TODO: THAT IS REDUNDANT DOCUMENTATION
    def simplify_value
      case @value_type
      when :item, :property
        return "#{@value.label} (#{@value.id})"
      when :wikidata_time
        return @value.fetch(:time, nil)
      when :external_id, :media, :text, :url, :gps_coordinates, :quantity
        return @value
      else
        return nil # TODO: Consider throwing an exception here
      end
    end
  end
end