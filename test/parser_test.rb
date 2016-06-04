require 'test_helper'

class ParserTest < Minitest::Test

  include GimmeWikidata


  # Parsing search results

  def test_it_parses_successful_search_response_into_search_object
    search = Parser.parse_search_response(sample_search_results)
    assert_kind_of Search, search
  end

  def test_it_parses_search_success_and_search_term
    search = Parser.parse_search_response(sample_search_results)
    assert search.was_successful?
    assert_equal "attila the hun", search.search_term
  end

  def test_it_parses_search_result_objects_with_correct_values
    search = Parser.parse_search_response(sample_search_results)
    refute search.results.empty?
    assert_equal 5, search.results.count
    assert search.results.all? {|sr| sr.is_a? SearchResult }
    assert_equal ["Q36724", "Q17987270", "Q4818461", "Q4818464", "Q4818462"], search.results.map(&:id)
    assert_equal ["Attila the Hun", "Attila the Hun", "Attila the Hun", "Attila the Hun", "Attila the Hun in popular culture"], search.results.map(&:label)
    assert_equal ["King of the Hunnic Empire", "Wikimedia disambiguation page", nil, "Calypsonian", nil], search.results.map(&:description)
  end

  def test_it_can_parse_empty_search_response
    search = Parser.parse_search_response(empty_search_results)
    assert search.empty?
  end

  def test_it_can_parse_a_no_search_response
    search = Parser.parse_search_response(no_search_results)

  end

  def test_it_throws_an_error_if_parsing_a_response_without_any_search_info
    assert_raises(ArgumentError) { Parser.parse_search_response(sample_item_claims) }
  end











  def test_it_says_search_response_was_successful_when_it_was_successful
    skip
  end

  def test_it_raises_argument_error_if_search_response_does_not_have_correct_form
    skip
  end

  def test_it_says_search_is_empty_when_its_empty
    skip
  end

  def test_it_can_parse_entities_response
    skip
  end

  def test_entity_response_throws_an_error_if_there_is_one_present
    skip
  end

  def test_entity_response_says_there_are_no_entities
    skip
  end

  def test_entity_response_says_when_it_is_unsuccessful
    skip
  end

end