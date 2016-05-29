require 'httparty'
require 'gimme_wikidata/entity'
require 'gimme_wikidata/enums'

module GimmeWikidata

  ##
  # Responsible for communication with the Wikidata API
  #
  # Handles the language and formatting of API calls
  #
  # Supported API actions:
  # - +wbsearchentities+ -> https://www.wikidata.org/w/api.php?action=help&modules=wbsearchentities
  # - +wbgetentities+ -> https://www.wikidata.org/w/api.php?action=help&modules=wbgetentities
  class WikidataAPI

    APIURL = 'https://www.wikidata.org/w/api.php?'
    FORMAT = 'json'

    @@language = Languages::DEFAULT

    ##
    # Set the language for the WikidataAPI.  This is used when communicating to the API.
    #
    # * *Args*    :
    #   - +language_symbol+ -> A symbol from the Languages Enum class
    # * *Returns* :
    #   - The string format of the language it is set to (or, of the current language if *not* set successfully)
    def self.set_language(language_symbol)
      new_lang = Languages.to_h[language_symbol]
      @@language = new_lang unless new_lang.nil?
      @@language
    end

    ##
    # Gets the language used to communicate to the Wikidata API
    def self.get_language
      @@language
    end

    ##
    # Builds a search query.
    #
    # Interfaces with the module described here: https://www.wikidata.org/w/api.php?action=help&modules=wbsearchentities
    #
    # Parameters:
    #   search => the search term to look for
    #   language => the language in which to search
    #   strict_language => disable language fallback or not
    #   type => either 'item' or 'property'
    #   limit => maximum number of things returned
    #   continue => offset of things
    def self.search_query (search: "wikidata", strict_language: false, type: 'item', limit: 50, continue: 0)
      url = [APIURL]
      url << "action=#{Actions::SEARCH}"
      url << "&format=#{FORMAT}"
      url << "&search=#{search}"
      url << "&language=#{@@language}"
      url << "&strictlanguage=#{strict_language}" unless strict_language == false
      url << "&type=#{type}" unless type == 'item'
      url << "&limit=#{limit}" unless limit == 50
      url << "&continue=#{continue}" unless continue == 0
      url.join
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
      url << '&action=' << Actions::GET_ENTITIES
      url << '&ids=' << ids.join('|')
      url << '&props=' << props.join('|')
      url.join
    end

    ##
    # Helper function to build a commonly-used URL
    #
    # Appends default format and language to the base Wikidata API URL
    def self.base_url
      url = [APIURL]
      url << 'format=' << FORMAT
      url << '&languages=' << @@language
      url.join
    end

    ##
    # Makes a call to the Wikidata API and formats the response into a symbolized hash
    #
    # * *Args*    :
    #   - +query+ -> The query for the API call
    # * *Returns* :
    #   - A hash representation of the API's response
    def self.make_call(query)
      response = HTTParty.get(query).to_h
      symbolize_recursive(response)
    end

  end

end