module GimmeWikidata

  ##
  # Models a Claim on Wikidata, which consists of a Property and a value
  #
  # Note that the value can be of any type (example: a number, a date), and is often another Item on Wikidata.
  #
  # For more details, please see: https://www.wikidata.org/wiki/Wikidata:Glossary#Claims_and_statements
  class Claim

    def initialize(property, value)
      @property = property
      @value = value
    end

  end

end