# frozen_string_literal: true

module Philiprehberger
  module Slug
    # Core slug generation logic
    module Generator
      # Generate a URL-safe slug from a string
      #
      # @param string [String] the input string
      # @param separator [String] the word separator
      # @param max [Integer, nil] maximum length
      # @param unique [Proc, nil] uniqueness checker
      # @return [String] the slug
      # @raise [Error] if input is not a string
      def self.call(string, separator: '-', max: nil, unique: nil)
        raise Error, "Input must be a String, got #{string.class}" unless string.is_a?(String)

        slug = build_slug(string, separator)
        slug = truncate_at_boundary(slug, max, separator) if max
        slug = ensure_unique(slug, separator, unique) if unique
        slug
      end

      def self.build_slug(string, separator)
        result = Transliterator.call(string)
        result = result.downcase
        result = result.gsub(/[^a-z0-9]+/, separator)
        result.gsub(/#{Regexp.escape(separator)}+/, separator).gsub(
          /\A#{Regexp.escape(separator)}|#{Regexp.escape(separator)}\z/, ''
        )
      end
      private_class_method :build_slug

      def self.truncate_at_boundary(slug, max, separator)
        return slug if slug.length <= max

        cut = slug[0, max]
        return cut if slug.length == max || slug[max] == separator

        last_sep = cut.rindex(separator)
        last_sep ? cut[0, last_sep] : cut
      end
      private_class_method :truncate_at_boundary

      def self.ensure_unique(slug, separator, checker)
        return slug unless checker.call(slug)

        counter = 2
        loop do
          candidate = "#{slug}#{separator}#{counter}"
          return candidate unless checker.call(candidate)

          counter += 1
        end
      end
      private_class_method :ensure_unique
    end
  end
end
