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

end
