require 'test_helper'

class GimmeWikidataTest < Minitest::Test

  include GimmeWikidata

  def teardown
    WikidataAPI.set_language(:DEFAULT)
  end

  ######################################
  # Smoke Tests
  ######################################

  def test_that_it_has_a_version_number
    refute_nil ::GimmeWikidata::VERSION
  end

  ######################################
  # WikidataAPI Tests
  ######################################

  def test_it_has_a_default_language
    assert_equal 'en', WikidataAPI.get_language
  end

  def test_it_does_not_change_language_if_new_language_is_unknown
    assert_equal 'en', WikidataAPI.set_language(:KLINGON)
  end

  def test_it_can_change_language
    assert_equal 'de', WikidataAPI.set_language(:GERMAN)
  end

  def test_it_has_an_api_url
    assert_equal 'https://www.wikidata.org/w/api.php?', WikidataAPI::API_URL
  end

  def test_it_has_a_data_format
    assert_equal 'json', WikidataAPI::Format
  end

  def test_it_can_build_search_query_with_default_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&search=wikidata&language=en', WikidataAPI.search_query
  end

  def test_it_can_build_a_base_url
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en', WikidataAPI.base_url
  end

  def test_it_can_build_search_query_with_specified_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&search=wikidata&language=en&strictlanguage=true&type=property&limit=10&continue=20', WikidataAPI.search_query(search: 'wikidata', strict_language: true, type: 'property', limit: 10, continue: 20)
  end

  def test_it_can_build_get_entties_query_with_default_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en&action=wbgetentities&ids=Q1&props=labels|descriptions|aliases', WikidataAPI.get_entities_query
  end

  def test_it_can_build_get_entities_query_with_specified_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en&action=wbgetentities&ids=Q1|Q2|Q3&props=labels', WikidataAPI.get_entities_query(ids: ['Q1', 'Q2', 'Q3'], props: [Props::LABELS])
  end

  ######################################
  # Parser Tests
  ######################################

  def test_it_can_parse_search_response
    skip
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
