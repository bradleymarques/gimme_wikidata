require 'test_helper'

class ParserTest < Minitest::Test

  include GimmeWikidata

  # Parsing Search Responses

  def test_it_parses_successful_search_response_into_search_object
    search = Parser.parse_search_response(ResponseFaker.fake('sample_search'))
    assert_kind_of Search, search
  end

  def test_it_says_search_response_was_successful_when_it_was_successful
    search = Parser.parse_search_response(ResponseFaker.fake('sample_search'))
    assert search.was_successful?
  end

  def test_it_correctly_parses_search_term
    search = Parser.parse_search_response(ResponseFaker.fake('sample_search'))
    assert_equal "attila the hun", search.search_term
  end

  def test_it_parses_search_result_objects_with_correct_values
    search = Parser.parse_search_response(ResponseFaker.fake('sample_search'))
    refute search.results.empty?
    assert_equal 5, search.results.count
    assert search.results.all? {|sr| sr.is_a? SearchResult }
    assert_equal ["Q36724", "Q17987270", "Q4818461", "Q4818464", "Q4818462"], search.results.map(&:id)
    assert_equal ["Attila the Hun", "Attila the Hun", "Attila the Hun", "Attila the Hun", "Attila the Hun in popular culture"], search.results.map(&:label)
    assert_equal ["King of the Hunnic Empire", "Wikimedia disambiguation page", nil, "Calypsonian", nil], search.results.map(&:description)
  end

  def test_it_can_parse_empty_search_response
    search = Parser.parse_search_response(ResponseFaker.fake('empty_search'))
    assert search.was_successful?
    assert search.empty?
  end

  def test_it_can_parse_a_no_search_response
    search = Parser.parse_search_response(ResponseFaker.fake('no_search'))
    refute search.was_successful?
    assert search.error
  end

  def test_it_throws_an_error_if_parsing_a_response_without_any_search_info
    assert_raises(ArgumentError) { search = Parser.parse_search_response(ResponseFaker.fake('simple_single_item')) }
  end

  # Parsing Get Entity Responses

  def test_it_can_parse_entity_response_into_entity_result_object
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('simple_single_item'))
    assert_kind_of EntityResult, entity_result
  end

  def test_entity_result_holds_correct_number_of_entities
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('multiple_entities'))
    assert_equal 5, entity_result.entities.count
  end

  def test_entity_result_is_successful_when_response_successful
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('simple_single_item'))
    assert entity_result.was_successful?
    refute entity_result.empty?
  end

  def test_entity_result_unsuccessful_when_response_unsuccessful
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('no_such_entity'))
    refute entity_result.was_successful?
  end

  def test_entity_response_throws_an_error_if_there_is_one_present
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('no_such_entity'))
    assert entity_result.error
  end

  def test_entity_response_empty_if_no_entities_in_response
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('no_such_entity'))
    assert entity_result.empty?
  end

  def test_parsed_entities_have_correct_entity_type
    entity_result = Parser.parse_entity_response(ResponseFaker.fake('mixed_entities'))
    assert_equal [Item, Property, Property, Item], entity_result.entities.map(&:class)
  end

  def test_parsed_entities_have_correct_id
    result = Parser.parse_entity_response(ResponseFaker.fake('mixed_entities'))
    assert_equal ['Q1', 'P106', 'P276', 'Q2'], result.entities.map(&:id)
  end

  def test_parsed_entities_have_correct_labels
    result = Parser.parse_entity_response(ResponseFaker.fake('mixed_entities'))
    assert_equal ['universe', 'occupation', 'location', 'Earth'], result.entities.map(&:label)
  end

  def test_parsed_entities_have_correct_descriptions
    result = Parser.parse_entity_response(ResponseFaker.fake('mixed_entities'))
    expected_descriptions = ['totality of planets, stars, galaxies, intergalactic space, or all matter or all energy']
    expected_descriptions << 'occupation of a person; see also "field of work" (Property:P101), "position held" (Property:P39)'
    expected_descriptions << 'location the item, physical object or event is within. In case of an administrative entity use P131. In case of a distinct terrain feature use P706.'
    expected_descriptions << 'third planet closest to the Sun in the Solar System'
    assert_equal expected_descriptions, result.entities.map(&:description)
  end

  def test_parsed_entities_have_correct_aliases
    result = Parser.parse_entity_response(ResponseFaker.fake('mixed_entities'))
    universe = result.entities.first
    expected_aliases = ['cosmos']
    expected_aliases << 'The Universe'
    expected_aliases << 'existence'
    expected_aliases << 'space'
    expected_aliases << 'outerspace'
    assert_equal expected_aliases, universe.aliases
  end

  def test_parsed_entities_have_claims_if_response_has_claims
    result = Parser.parse_entity_response(ResponseFaker.fake('full_entity'))
    ireland = result.entities.first
  end

  def test_parsed_claims_have_correct_ids
    skip
  end

end