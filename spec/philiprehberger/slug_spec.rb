# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Slug do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '.generate' do
    it 'generates a basic slug' do
      expect(described_class.generate('Hello World')).to eq('hello-world')
    end

    it 'handles multiple spaces and punctuation' do
      expect(described_class.generate('Hello,  World!')).to eq('hello-world')
    end

    it 'strips leading and trailing separators' do
      expect(described_class.generate('--hello--')).to eq('hello')
    end

    it 'collapses multiple separators' do
      expect(described_class.generate('hello   world')).to eq('hello-world')
    end

    it 'transliterates Latin diacritics' do
      expect(described_class.generate('Héllo Wörld')).to eq('hello-world')
    end

    it 'transliterates Cyrillic characters' do
      expect(described_class.generate('Привет мир')).to eq('privet-mir')
    end

    it 'transliterates Greek characters' do
      expect(described_class.generate('Ελληνικά')).to eq('ellinika')
    end

    it 'uses a custom separator' do
      expect(described_class.generate('Hello World', separator: '_')).to eq('hello_world')
    end

    it 'truncates at word boundary with max length' do
      expect(described_class.generate('hello beautiful world', max: 15)).to eq('hello-beautiful')
    end

    it 'truncates without boundary when no separator found' do
      expect(described_class.generate('abcdefghij', max: 5)).to eq('abcde')
    end

    it 'does not truncate when slug is within max' do
      expect(described_class.generate('hi', max: 10)).to eq('hi')
    end

    it 'handles uniqueness callback' do
      existing = ['hello-world']
      result = described_class.generate('Hello World', unique: ->(s) { existing.include?(s) })
      expect(result).to eq('hello-world-2')
    end

    it 'increments uniqueness counter' do
      existing = %w[hello-world hello-world-2]
      result = described_class.generate('Hello World', unique: ->(s) { existing.include?(s) })
      expect(result).to eq('hello-world-3')
    end

    it 'returns slug directly when unique check passes' do
      result = described_class.generate('Hello World', unique: ->(_s) { false })
      expect(result).to eq('hello-world')
    end

    it 'handles empty string' do
      expect(described_class.generate('')).to eq('')
    end

    it 'raises Error for non-string input' do
      expect { described_class.generate(123) }.to raise_error(described_class::Error)
    end

    it 'handles special characters only' do
      expect(described_class.generate("!@\#$%")).to eq('')
    end
  end

  describe 'extended edge cases' do
    it 'handles numbers in input' do
      expect(described_class.generate('Product 123')).to eq('product-123')
    end

    it 'handles mixed case with numbers' do
      expect(described_class.generate('iPhone 15 Pro Max')).to eq('iphone-15-pro-max')
    end

    it 'handles tab and newline whitespace' do
      expect(described_class.generate("hello\tworld\nfoo")).to eq('hello-world-foo')
    end

    it 'handles max length exactly at word boundary' do
      expect(described_class.generate('hello world', max: 11)).to eq('hello-world')
    end

    it 'handles max length cutting mid-word' do
      expect(described_class.generate('hello world', max: 8)).to eq('hello')
    end

    it 'handles uniqueness with custom separator' do
      existing = ['hello_world']
      result = described_class.generate('Hello World', separator: '_', unique: ->(s) { existing.include?(s) })
      expect(result).to eq('hello_world_2')
    end

    it 'handles Cyrillic full sentence' do
      expect(described_class.generate('Москва столица России')).to eq('moskva-stolitsa-rossii')
    end

    it 'handles Polish diacritics' do
      expect(described_class.generate('Łódź')).to eq('lodz')
    end

    it 'handles Czech diacritics' do
      expect(described_class.generate('Příliš žluťoučký')).to eq('prilis-zlutoucky')
    end

    it 'handles Turkish characters' do
      expect(described_class.generate('İstanbul Şehri')).to eq('istanbul-sehri')
    end
  end

  describe '.transliterate' do
    it 'transliterates accented characters' do
      expect(described_class.transliterate('café')).to eq('cafe')
    end

    it 'transliterates German characters' do
      expect(described_class.transliterate('straße')).to eq('strasse')
    end

    it 'leaves ASCII unchanged' do
      expect(described_class.transliterate('hello')).to eq('hello')
    end

    it 'transliterates Scandinavian characters' do
      expect(described_class.transliterate('Ångström')).to eq('Angstrom')
    end

    it 'transliterates French ligatures' do
      expect(described_class.transliterate('cœur')).to eq('coeur')
    end

    it 'transliterates Greek characters' do
      expect(described_class.transliterate('Ωmega')).to eq('Omega')
    end
  end

  describe '.generate_batch' do
    it 'generates unique slugs for duplicate inputs' do
      result = described_class.generate_batch(%w[Hello Hello Hello])
      expect(result).to eq(%w[hello hello-2 hello-3])
    end

    it 'handles mixed inputs' do
      result = described_class.generate_batch(['Hello World', 'Goodbye', 'Hello World'])
      expect(result).to eq(%w[hello-world goodbye hello-world-2])
    end

    it 'respects max length' do
      result = described_class.generate_batch(['Hello Beautiful World', 'Another Long Title'], max: 15)
      expect(result[0]).to eq('hello-beautiful')
    end

    it 'raises Error for non-array input' do
      expect { described_class.generate_batch('not an array') }.to raise_error(described_class::Error)
    end

    it 'returns empty array for empty input' do
      expect(described_class.generate_batch([])).to eq([])
    end
  end

  describe 'custom_mapping' do
    it 'applies custom character replacements' do
      result = described_class.generate('Hello & World', custom_mapping: { '&' => 'and' })
      expect(result).to eq('hello-and-world')
    end

    it 'overrides default transliteration mapping' do
      result = described_class.generate('Straße', custom_mapping: { 'ß' => 'sz' })
      expect(result).to eq('strasze')
    end

    it 'works with transliterate method' do
      result = described_class.transliterate('A & B', custom_mapping: { '&' => 'and' })
      expect(result).to eq('A and B')
    end

    it 'works with generate_batch' do
      result = described_class.generate_batch(['A & B', 'C & D'], custom_mapping: { '&' => 'and' })
      expect(result).to eq(%w[a-and-b c-and-d])
    end
  end

  describe '.valid_slug?' do
    it 'returns true for a valid slug' do
      expect(described_class.valid_slug?('hello-world')).to be true
    end

    it 'returns true for a single word' do
      expect(described_class.valid_slug?('hello')).to be true
    end

    it 'returns true with custom separator' do
      expect(described_class.valid_slug?('hello_world', separator: '_')).to be true
    end

    it 'returns false for uppercase letters' do
      expect(described_class.valid_slug?('Hello-World')).to be false
    end

    it 'returns false for leading separator' do
      expect(described_class.valid_slug?('-hello')).to be false
    end

    it 'returns false for trailing separator' do
      expect(described_class.valid_slug?('hello-')).to be false
    end

    it 'returns false for consecutive separators' do
      expect(described_class.valid_slug?('hello--world')).to be false
    end

    it 'returns false for empty string' do
      expect(described_class.valid_slug?('')).to be false
    end

    it 'returns false for spaces' do
      expect(described_class.valid_slug?('hello world')).to be false
    end

    it 'returns false for non-String without raising' do
      expect(described_class.valid_slug?(123)).to be false
    end

    it 'returns false for Unicode characters' do
      expect(described_class.valid_slug?('café')).to be false
    end

    it 'returns true for numeric slug' do
      expect(described_class.valid_slug?('123')).to be true
    end
  end

  describe '.humanize' do
    it 'converts a slug to title case' do
      expect(described_class.humanize('hello-world')).to eq('Hello World')
    end

    it 'capitalizes a single word' do
      expect(described_class.humanize('hello')).to eq('Hello')
    end

    it 'handles slugs with numbers' do
      expect(described_class.humanize('product-123-review')).to eq('Product 123 Review')
    end

    it 'uses custom separator' do
      expect(described_class.humanize('hello_world', separator: '_')).to eq('Hello World')
    end

    it 'capitalizes first word only with :first' do
      expect(described_class.humanize('hello-beautiful-world', capitalize: :first)).to eq('Hello beautiful world')
    end

    it 'applies no capitalization with :none' do
      expect(described_class.humanize('hello-world', capitalize: :none)).to eq('hello world')
    end

    it 'returns empty string for empty input' do
      expect(described_class.humanize('')).to eq('')
    end

    it 'raises Error for non-String input' do
      expect { described_class.humanize(123) }.to raise_error(described_class::Error)
    end

    it 'raises Error for unknown capitalize option' do
      expect { described_class.humanize('hello', capitalize: :invalid) }.to raise_error(described_class::Error)
    end
  end

  describe '.detect_separator' do
    it 'returns :dash for a dash-separated string' do
      expect(described_class.detect_separator('foo-bar-baz')).to eq(:dash)
    end

    it 'returns :underscore for an underscore-separated string' do
      expect(described_class.detect_separator('foo_bar_baz')).to eq(:underscore)
    end

    it 'returns nil for a plain string with no separators' do
      expect(described_class.detect_separator('plain')).to be_nil
    end

    it 'returns nil for an empty string' do
      expect(described_class.detect_separator('')).to be_nil
    end

    it 'returns nil for nil input' do
      expect(described_class.detect_separator(nil)).to be_nil
    end

    it 'returns nil for non-String input' do
      expect(described_class.detect_separator(123)).to be_nil
    end

    it 'returns :dash when dashes outnumber underscores' do
      expect(described_class.detect_separator('a-b_c-d')).to eq(:dash)
    end

    it 'returns :underscore when underscores outnumber dashes' do
      expect(described_class.detect_separator('a_b_c-d')).to eq(:underscore)
    end
  end

  describe '.parameterize' do
    it 'generates a slug like generate' do
      expect(described_class.parameterize('Hello World!')).to eq('hello-world')
    end

    it 'respects custom separator' do
      expect(described_class.parameterize('Hello World', separator: '_')).to eq('hello_world')
    end

    it 'truncates with max at word boundary' do
      expect(described_class.parameterize('Hello Beautiful World', max: 16)).to eq('hello-beautiful')
    end
  end

  describe '.join' do
    it 'joins multiple slug parts with the default separator' do
      expect(described_class.join('user', 'jane-doe', '42')).to eq('user-jane-doe-42')
    end

    it 'collapses duplicate separators introduced by the caller' do
      expect(described_class.join('user-', '-jane-doe-', '42')).to eq('user-jane-doe-42')
    end

    it 'trims leading and trailing separators from the result' do
      expect(described_class.join('-foo', 'bar-')).to eq('foo-bar')
    end

    it 'skips nil and empty parts' do
      expect(described_class.join('foo', nil, '', 'bar')).to eq('foo-bar')
    end

    it 'honors a custom separator' do
      expect(described_class.join('foo', 'bar', 'baz', separator: '_')).to eq('foo_bar_baz')
    end

    it 'raises Error on non-String parts' do
      expect { described_class.join('foo', 42) }.to raise_error(Philiprehberger::Slug::Error)
    end

    it 'returns an empty string when all parts are empty or nil' do
      expect(described_class.join(nil, '', nil)).to eq('')
    end
  end
end
