module GimmeWikidata

  class Search

    @search_term
    @success
    @results

    attr_reader :search_term, :success
    attr_accessor :results

    def initialize(success, search_term)
      @search_term = search_term
      @success = (success == 1)
      @results = []
    end

    def was_successful?
      @success
    end

    def empty?
      results.count == 0
    end

  end

  class SearchResult

    @id
    @type
    @label
    @description

    def initialize(id, label, description)
      @id = id
      @label = label
      @description = description

      case @id[0]
      when 'Q'
        @type = Item
      when 'P'
        @type = Property
      else
        @type = :unknown_type
      end
    end

  end


end