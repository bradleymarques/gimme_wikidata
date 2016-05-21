require 'gimme_wikidata/wikidata_api'

module GimmeWikidata

  ##
  # Models an Item on Wikidata.
  class Item < Entity

    @claims       # Array of Claim objects that are recorded for the Item on Wikidata

    @state        # One of [:unverified, :verified, :basics, :full]
                  #   :unvalidated  => Has only an id.  No API call has been made at all, so we're not even sure if this thing exists on Wikidata
                  #   :invalid      => Does not exists on Wikidata
                  #   :valid        => Has only an id.  An API call has been made, and we're sure this Item exists on Wikidata
                  #   :basics       => Has an id, label, description and aliases
                  #   :full         => The full Item, including Claims

    attr_reader :id, :label, :description, :aliases, :claims

    ##
    # Simply appends 'Q' to the @id to make it Wikidata-friendly
    def wikidata_id
      "Q#{@id}"
    end

    def initialize(id)
      @state = :bare
      @id = id
      fetch_basic_data()




      #if exists_on_wikidata?
      #  @state = :valid
      #else
      #  raise ArgumentError, "No such Item with id '#{@id}' exists on Wikidata"
      #end

    end

    def fetch_basic_data
      basic_data = WikidataApi.fetch_entities(self, :basic)
      puts basic_data
    end

  end

end