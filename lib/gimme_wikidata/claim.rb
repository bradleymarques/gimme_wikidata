module GimmeWikidata

  ##
  # Models a Claim on Wikidata, which essentially pairs a Property to a Snak
  class Claim

    @property       = Property.new
    @snak           = Snak.new

  end

end