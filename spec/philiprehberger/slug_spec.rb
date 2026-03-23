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
end
