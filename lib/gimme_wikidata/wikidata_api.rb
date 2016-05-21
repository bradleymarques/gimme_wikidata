require 'httparty'
require 'gimme_wikidata/entity'
require 'gimme_wikidata/enums'

module GimmeWikidata

  class WikidataAPI

    API_URL   = 'https://www.wikidata.org/w/api.php?'
    Format    = 'json'

    @@language = Languages::DEFAULT

    ##
    # Set the language for the WikidataAPI.  This will be used when communicating to the API.
    def self.set_language(language_symbol)
      new_lang = Languages.to_h[language_symbol]
      @@language = new_lang unless new_lang.nil?
      @@language
    end

    def self.get_language
      @@language
    end

    ##
    # Builds a search query.
    #
    # Interfaces with the module described here: https://www.wikidata.org/w/api.php?action=help&modules=wbsearchentities
    #
    # search              - the search term to look for
    # language            - the language in which to search
    # strict_language     - disable language fallback or not
    # type                - either 'item' or 'property'
    # limit               - maximum number of things returned
    # continue            - offset of things
    def self.search_query (search: "wikidata", strict_language: false, type: 'item', limit: 50, continue: 0)
      url = [API_URL]
      url << ['action=', Actions::SEARCH]
      url << ['&format=', Format]
      url << ['&search=', search]
      url << ['&language=', @@language]
      url << ['&strictlanguage=', strict_language] unless strict_language == false
      url << ['&type=', type] unless type == 'item'
      url << ['&limit=', limit] unless limit == 50
      url << ['&continue=', continue] unless continue == 0
      url.flatten.join
    end

    ##
    # Build a query to get Entities (Items and Properties) from Wikidata.
    #
    # Interfaces the the module described here: https://www.wikidata.org/w/api.php?action=help&modules=wbgetentities
    #
    # ids         - an array of strings representing the ids of the entities on Wikidata.  Example: ['Q1', 'Q3', 'P106']
    # props       - the properties to get.  See the Props class
    def self.get_entities_query(ids: ['Q1'], props: [Props::LABELS, Props::DESCRIPTIONS, Props::ALIASES])
      url = [base_url]
      url << ['&action=', Actions::GET_ENTITIES]
      url << ['&ids=', ids.join('|')]
      url << ['&props=', props.join('|')]
      url.flatten.join
    end

    ##
    # Helper function to build a commonly-used URL
    def self.base_url
      url = [API_URL]
      url << ['format=', Format]
      url << ['&languages=', @@language]
      url.flatten.join
    end

  end

end