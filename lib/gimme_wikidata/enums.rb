require 'ruby-enum'

module GimmeWikidata

  class Languages
    include Ruby::Enum

    define :DEFAULT, 'en'
    define :ENGLISH, 'en'
    define :GERMAN, 'de'
  end

  class Actions
    include Ruby::Enum

    define :SEARCH, 'wbsearchentities'
    define :GET_ENTITIES, 'wbgetentities'
  end

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