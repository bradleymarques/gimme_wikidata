module GimmeWikidata

  ##
  # Models a Snak on Wikidata, which is a data point with a specific type.
  #
  # Snaks are often of type Item:
  # For instance, Item 'Attila the Hun' (Q36724) has a Claim that says his 'child' Property (P40) is Item 'Ellac' (Q518067)
  class Snak

    @type         = nil
    @value        = nil

  end

end