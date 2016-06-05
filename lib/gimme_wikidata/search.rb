module GimmeWikidata

  ##
  # TODO: DOCUMENT THIS CLASS
  class Search

    attr_reader :search_term, :success, :error
    attr_accessor :results

    def initialize(success, error, search_term, results = [])
      @search_term = search_term
      @success = (success == 1)
      @results = results
      @error = error
    end

    def was_successful?
      @success
    end

    def empty?
      results.empty?
    end

    def top_result
      @results.first
    end

  end

  ##
  # TODO: DOCUMENT THIS CLASS
  class SearchResult

    attr_accessor :id, :type, :label, :description

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