require 'ruby-enum'

module GimmeWikidata

  ##
  # The languages possible when communicating with the Wikidata API
  #
  # See: https://www.wikidata.org/w/api.php?action=help&modules=wbgetentities for a list of the supported languages
  class Languages
    include Ruby::Enum

    define :DEFAULT, 'en'
    define :ENGLISH, 'en'
    define :GERMAN, 'de'
    # etc...

  end

  ##
  # Models an enum of the 'action' parameters in Wikidata API calls
  #
  # See https://www.wikidata.org/w/api.php?action=help&modules=main
  class Actions
    include Ruby::Enum

    define :SEARCH, 'wbsearchentities'
    define :GET_ENTITIES, 'wbgetentities'
  end

  ##
  # Models an enum of the 'props' arguments in wbgetentity calls.
  #
  # See https://www.wikidata.org/w/api.php?action=help&modules=wbgetentities
  class Props
    include Ruby::Enum

    define :INFO, 'info'
    define :SITELINKS, 'sitelinks'
    define :ALIASES, 'aliases'
    define :LABELS, 'labels'
    define :DESCRIPTIONS, 'descriptions'
    define :CLAIMS, 'claims'
    define :DATATYPE, 'datatype'

  end

end