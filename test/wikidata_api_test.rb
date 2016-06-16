require 'test_helper'

class WikidataAPITest < Minitest::Test

  include GimmeWikidata

  # Setup, teardown, and common functionality:

  def teardown
    WikidataAPI.set_language(:ENGLISH)
  end

  # Tests:

  # Basic properties:

  def test_it_has_correct_api_url
    assert_equal 'https://www.wikidata.org/w/api.php?', WikidataAPI::APIURL
  end

  def test_it_has_correct_data_format
    assert_equal 'json', WikidataAPI::FORMAT
  end

  def test_it_defaults_to_english_language
    assert_equal 'en', WikidataAPI.get_language
  end

  # Setting and using language:

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
    refute_nil (/&language=de/) =~ first_query
    refute_nil (/&language=de/) =~ second_query
  end

  # Building API calls:

  def test_it_can_build_a_base_url
    assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en', WikidataAPI.base_url
  end

  def test_it_can_build_search_query_with_default_parameters
    assert_equal 'https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&search=wikidata&language=en', WikidataAPI.search_query
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

  def test_it_raises_error_if_get_entities_query_called_with_string
    assert_raises(ArgumentError) { WikidataAPI.get_entities_query("Q1") }
  end

  def test_it_raises_error_if_get_entities_query_called_with_invalid_wikidata_ids
    assert_raises(ArgumentError) { WikidataAPI.get_entities_query(["Q1", "P1", "T5"]) }
  end

  # Making API Calls:

  def test_it_can_make_a_search_call
    flunk 'THIS TEST NEEDS TO MOCK THE API, NOT ACTUALLY RELY ON AN INTERNET CONNECTION TO PASS'
    search_query = WikidataAPI.search_query('Attila the Hun')
    assert WikidataAPI.make_call(search_query) # asserts no exceptions raised
  end

  def test_it_can_make_a_get_entities_call
    flunk 'THIS TEST NEEDS TO MOCK THE API, NOT ACTUALLY RELY ON AN INTERNET CONNECTION TO PASS'
    get_query = WikidataAPI.get_entities_query(['Q1'])
    assert WikidataAPI.make_call(get_query) # asserts no exceptions raised
  end

  def test_it_returns_a_hash_on_all_calls
    flunk 'THIS TEST NEEDS TO MOCK THE API, NOT ACTUALLY RELY ON AN INTERNET CONNECTION TO PASS'
    search_response = WikidataAPI.make_call(WikidataAPI.search_query('Attila The Hun'))
    entity_response = WikidataAPI.make_call(WikidataAPI.get_entities_query(['Q36724']))
    assert_kind_of Hash, search_response
    assert_kind_of Hash, entity_response
  end

  def test_it_returns_error_messages_from_the_wikidata_api
    flunk 'THIS TEST NEEDS TO MOCK THE API, NOT ACTUALLY RELY ON AN INTERNET CONNECTION TO PASS'
    search_query = WikidataAPI.get_entities_query(['Q0']) # There is no entity Q0
    response = WikidataAPI.make_call(search_query)
    refute_nil response.fetch(:error, nil)
  end

  def test_it_does_something_appropriate_when_there_is_no_internet_connection
    flunk 'THIS TEST NEEDS TO MOCK THE API, NOT ACTUALLY RELY ON AN INTERNET CONNECTION TO PASS'
    skip "TODO: Figure out how to test this.  Maybe with stubbing a non-functional HTTParty?  There is a gem called Webmock: https://github.com/bblimke/webmock"
  end

end