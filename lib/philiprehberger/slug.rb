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
    # @param custom_mapping [Hash, nil] custom character replacements to augment transliteration
    # @return [String] the generated slug
    # @raise [Error] if input is not a string
    def self.generate(string, separator: '-', max: nil, unique: nil, custom_mapping: nil)
      Generator.call(string, separator: separator, max: max, unique: unique, custom_mapping: custom_mapping)
    end

    # Generate unique slugs for an array of strings with automatic deduplication
    #
    # @param strings [Array<String>] the input strings
    # @param separator [String] the separator character
    # @param max [Integer, nil] maximum length
    # @param custom_mapping [Hash, nil] custom character replacements
    # @return [Array<String>] array of unique slugs
    def self.generate_batch(strings, separator: '-', max: nil, custom_mapping: nil)
      raise Error, 'Input must be an Array' unless strings.is_a?(Array)

      seen = {}
      strings.map do |string|
        base = generate(string, separator: separator, max: max, custom_mapping: custom_mapping)
        if seen.key?(base)
          seen[base] += 1
          "#{base}#{separator}#{seen[base]}"
        else
          seen[base] = 1
          base
        end
      end
    end

    # Transliterate Unicode characters to ASCII
    #
    # @param string [String] the input string
    # @param custom_mapping [Hash, nil] custom character replacements
    # @return [String] the transliterated string
    def self.transliterate(string, custom_mapping: nil)
      Transliterator.call(string, custom_mapping: custom_mapping)
    end
  end
end
