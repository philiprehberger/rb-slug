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

    # Rails-compatible alias for `generate` for callers familiar with
    # `ActiveSupport::Inflector#parameterize`.
    #
    # @param string [String] the input string
    # @param separator [String] the separator character
    # @param max [Integer, nil] maximum length, truncated at word boundary
    # @param custom_mapping [Hash, nil] custom character replacements
    # @return [String] the generated slug
    def self.parameterize(string, separator: '-', max: nil, custom_mapping: nil)
      generate(string, separator: separator, max: max, custom_mapping: custom_mapping)
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

    # Check whether a string is a well-formed slug
    #
    # @param string [String] the string to validate
    # @param separator [String] the allowed separator character (default: "-")
    # @return [Boolean] true if the string is a valid slug
    def self.valid_slug?(string, separator: '-')
      return false unless string.is_a?(String)
      return false if string.empty?

      sep = Regexp.escape(separator)
      string.match?(/\A[a-z0-9]+(?:#{sep}[a-z0-9]+)*\z/)
    end

    # Convert a slug back to a human-readable title
    #
    # @param slug [String] the slug to humanize
    # @param separator [String] the separator used in the slug (default: "-")
    # @param capitalize [Symbol] capitalization strategy: :words, :first, or :none
    # @return [String] the human-readable string
    # @raise [Error] if input is not a String
    def self.humanize(slug, separator: '-', capitalize: :words)
      raise Error, "Input must be a String, got #{slug.class}" unless slug.is_a?(String)
      return '' if slug.empty?

      result = slug.gsub(separator, ' ')
      case capitalize
      when :words then result.gsub(/\b[a-z]/, &:upcase)
      when :first then result.sub(/\A[a-z]/, &:upcase)
      when :none then result
      else raise Error, "Unknown capitalize option: #{capitalize}"
      end
    end
  end
end
