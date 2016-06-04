require 'test_helper'

class WikidataAPITest < Minitest::Test

  include GimmeWikidata

  def teardown
    WikidataAPI.set_language(:DEFAULT)
  end

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

end