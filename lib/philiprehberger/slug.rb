# frozen_string_literal: true

require_relative 'slug/version'
require_relative 'slug/transliterator'
require_relative 'slug/generator'

module Philiprehberger
  module Slug
    class Error < StandardError; end

    # Generate a URL-safe slug from a string
    #
    # @param string [String] the input string
    # @param separator [String] the separator character
    # @param max [Integer, nil] maximum length, truncated at word boundary
    # @param unique [Proc, nil] callable that returns true if slug already exists
    # @return [String] the generated slug
    # @raise [Error] if input is not a string
    def self.generate(string, separator: '-', max: nil, unique: nil)
      Generator.call(string, separator: separator, max: max, unique: unique)
    end

    # Transliterate Unicode characters to ASCII
    #
    # @param string [String] the input string
    # @return [String] the transliterated string
    def self.transliterate(string)
      Transliterator.call(string)
    end
  end
end
