##
# Class to deep symbolize keys in a Hash and Array of Hashes
#
# Code written by EdvardM at: http://apidock.com/rails/Hash/deep_symbolize_keys
module SymbolizeHelper
  extend self

  def symbolize_recursive(hash)
    {}.tap do |h|
      hash.each { |key, value| h[key.to_sym] = transform(value) }
    end
  end

  private

  def transform(thing)
    case thing
    when Hash; symbolize_recursive(thing)
    when Array; thing.map { |v| transform(v) }
    else; thing
    end
  end

  refine Hash do
    def deep_symbolize_keys
      SymbolizeHelper.symbolize_recursive(self)
    end
  end
end

class Array
  ##
  # Merges an Array of Hases into a single Hash, keeping duplicate values in an Array
  #
  # Raises StandardError if the Array is not an Array of Hashes, exclusively
  def merge_hashes
    raise StandardError.new "Array is not an Array of Hashes" unless self.all? {|e| e.is_a? Hash}
    self.each_with_object({}) do |el, h|
      el.each { |k, v| h[k] = h[k] ? [*h[k]] << v : v }
    end
  end
end