##
# A helper class used in GimmeWikidata test suites that fakes responses from the Wikidata API by loading up predefined json files.
class ResponseFaker

  require 'json'

  def self.fake(name)
    path = get_file_path(name + '.json')
    fake_response = json_file_to_hash(path)
    SymbolizeHelper.symbolize_recursive(fake_response)
  end

  private

  def self.json_file_to_hash(path)
    JSON.parse(File.read(path))
  end

  def self.get_file_path(filename)
    File.join(Dir.pwd, 'test', 'test_api_results', filename)
  end

end