module GimmeWikidata

  ##
  # Responsible for parsing the JSON data from the Wikidata API
  #
  class Parser

    ##
    # Parses the results from a search query
    def self.parse_search_response(response)
      return ArgumentError 'response did not seem to be a response from a search query' if response[:searchinfo].nil?
      search = Search.new(response[:success], response[:searchinfo][:search])
      return search unless search.was_successful?
      response[:search].each do |r|
        search.results << SearchResult.new(r[:id], r[:label], r[:description])
      end
      return search
    end

  end

end