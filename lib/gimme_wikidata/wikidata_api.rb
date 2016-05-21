require 'httparty'
require 'gimme_wikidata/entity'
require 'gimme_wikidata/enums'

module GimmeWikidata

  class WikidataAPI

    API_URL = 'https://www.wikidata.org/w/api.php?'

    @@language = Languages::DEFAULT

    def self.set_language(language_symbol)
      new_lang = Languages.to_h[language_symbol]
      @@language = new_lang unless new_lang.nil?
      @@language
    end

    def self.get_language
      @@language
    end


  end

end