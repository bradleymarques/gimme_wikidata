require 'ruby-enum'

module GimmeWikidata

  class Languages
    include Ruby::Enum

    define :DEFAULT, 'en'
    define :ENGLISH, 'en'
    define :GERMAN, 'de'
  end

end