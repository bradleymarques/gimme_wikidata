require 'httparty'
require 'gimme_wikidata/entity'

module GimmeWikidata

  class WikidataApi

    Language    = 'en' # The language with which to query the Wikidata API
    Api_Url     = 'https://www.wikidata.org/w/api.php?'
    Data_Format = 'json'

    Request_Detail = {
      basic:          'aliases|labels|descriptions',
      with_claims:    'aliases|labels|descriptions|claims',
      full:           'info|sitelinks|aliases|labels|descriptions|claims|datatype'
    }

    Actions = {
      get_entities:     'wbgetentities'
    }

    def self.fetch_entities(entity_array, request_detail = :basic)
      request = entity_request(entity_array, request_detail)
      response = HTTParty.get(request)
      puts response
      parse_entity_response(response)
    end

    def self.parse_entity_response
      return nil
    end

    private

    ##
    # Builds a request for entities.
    #
    # entity_array can be an array of mixed Items and Properties
    def self.entity_request(entity_array, request_detail = :basic)

      if (entity_array.is_a? Array)
        ids = entity_array.map { |e| e.wikidata_id}
      elsif (entity_array.is_a? Entity)
        ids = entity_array.wikidata_id
      else
        raise ArgumentError 'entity_array not an Array of Entities or a single Entity'
      end

      return [base_url, '&action=', Actions[:get_entities], '&props=', Request_Detail[request_detail], '&ids=', ids].join('')
    end

    def self.base_url
      return [Api_Url, 'format=', Data_Format, '&languages=', Language].join('')
    end

  end

end