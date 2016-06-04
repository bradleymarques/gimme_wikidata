require 'test_helper'

class WikidataAPITest < Minitest::Test

  include GimmeWikidata

  # Setup, teardown, and common functionality:

  def teardown
    WikidataAPI.set_language(:ENGLISH)
  end

  # Tests:

  def test_it_defaults_to_english_language
    assert_equal 'en', WikidataAPI.get_language
  end

  def test_it_does_not_change_language_if_new_language_is_unknown
    assert_equal 'en', WikidataAPI.set_language(:KLINGON)
  end

  def test_it_can_change_language
    assert_equal 'de', WikidataAPI.set_language(:GERMAN)
  end

  def test_it_keeps_its_language_set_over_multiple_api_calls
    WikidataAPI.set_language(:GERMAN)
    first_query = WikidataAPI.search_query('Hotdog')
    second_query = WikidataAPI.search_query('Cheese')
    refute_nil /&language=de/ =~ first_query
    refute_nil /&language=de/ =~ second_query
  end

  def test_it_has_correct_api_url
    assert_equal 'https://www.wikidata.org/w/api.php?', WikidataAPI::APIURL
  end

  def test_it_has_correct_data_format
    assert_equal 'json', WikidataAPI::FORMAT
  end

  def test_it_can_build_search_query_with_default_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&search=wikidata&language=en', WikidataAPI.search_query
  end

  def test_it_can_build_a_base_url
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en', WikidataAPI.base_url
  end

  def test_it_can_build_search_query_with_specified_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&search=wikidata&language=en&strictlanguage=true&type=property&limit=10&continue=20', WikidataAPI.search_query('wikidata', strict_language: true, type: 'property', limit: 10, continue: 20)
  end

  def test_it_can_build_get_entties_query_with_default_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en&action=wbgetentities&ids=Q1&props=labels|descriptions|aliases', WikidataAPI.get_entities_query
  end

  def test_it_can_build_get_entities_query_with_specified_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en&action=wbgetentities&ids=Q1|Q2|Q3&props=labels', WikidataAPI.get_entities_query(['Q1', 'Q2', 'Q3'], props: [Props::LABELS])
  end

end