require 'httparty'
require 'gimme_wikidata/entity'
require 'gimme_wikidata/enums'

module GimmeWikidata

  class WikidataAPI

    API_URL   = 'https://www.wikidata.org/w/api.php?'
    Format    = 'json'

    @@language = Languages::DEFAULT

    def self.set_language(language_symbol)
      new_lang = Languages.to_h[language_symbol]
      @@language = new_lang unless new_lang.nil?
      @@language
    end

    def self.get_language
      @@language
    end

    ##
    # Builds a search query.  Interfaces with the module described here: https://www.wikidata.org/w/api.php?action=help&modules=wbsearchentities
    #
    # search              - the search term to look for
    # language            - the language in which to search
    # strict_language     - disable language fallback or not
    # type                - either 'item' or 'property'
    # limit               - maximum number of things returned
    # continue            - offset of things
    def self.build_search_query (search: "wikidata", language: @@language, strict_language: false, type: 'item', limit: 50, continue: 0)
      url = [API_URL]
      url << ['action=', Actions::SEARCH]
      url << ['&format=', Format]
      url << ['&search=', search]
      url << ['&language=', language]
      url << ['&strinctlanguage=', strict_language] unless strict_language == false
      url << ['&type=', type] unless type == 'item'
      url << ['&limit=', limit] unless limit == 50
      url << ['&continue=' << continue] unless continue == 0
      url.flatten.join
    end

    def self.base_url
      nil
    end


  end

end