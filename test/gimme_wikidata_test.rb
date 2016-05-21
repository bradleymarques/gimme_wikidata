require 'test_helper'

class GimmeWikidataTest < Minitest::Test

  include GimmeWikidata

  ######################################
  # Smoke Tests
  ######################################

  def test_that_it_has_a_version_number
    refute_nil ::GimmeWikidata::VERSION
  end

  ######################################
  # WikidataApi Tests
  ######################################

  def test_that_it_has_expected_constants
    assert_equal 'en', WikidataApi::Language
    assert_equal 'https://www.wikidata.org/w/api.php?', WikidataApi::Api_Url
    assert_equal 'json', WikidataApi::Data_Format
  end

  def test_it_builds_correct_query_for_one_item
    skip 'TODO: I will need to stub the Items for this test'
    #item = Item.new(332528)
    #assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en&action=wbgetentities&ids=Q332528&props=aliases|labels|descriptions', WikidataApi.entity_request([item])
  end

  def test_it_builds_correct_query_for_mutiple_items
    skip 'TODO: I will need to stub the Items for this test'
    #item_1 = Item.new(332528)
    #item_2 = Item.new(84)
    #assert_equal 'https://www.wikidata.org/w/api.php?format=json&languages=en&action=wbgetentities&ids=Q332528|Q84&props=aliases|labels|descriptions', WikidataApi.entity_request([item_1, item_2])
  end

  ######################################
  # Item Tests
  ######################################

  def test_if_created_with_a_valid_id_will_verify_itself_and_succeed
    assert_instance_of Item, Item.new(332528)
  end

  def test_it_raises_argument_error_if_created_with_an_invalid_id
    assert_raises(ArgumentError) { Item.new('invalid_id') }
  end

end
