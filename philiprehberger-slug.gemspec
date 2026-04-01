# frozen_string_literal: true

require_relative 'lib/philiprehberger/slug/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-slug'
  spec.version = Philiprehberger::Slug::VERSION
  spec.authors = ['Philip Rehberger']
  spec.email = ['me@philiprehberger.com']

  spec.summary = 'URL-friendly slug generator with Unicode transliteration and collision-aware uniqueness'
  spec.description = 'Generate URL-safe slugs from any string with built-in Unicode transliteration, ' \
                     'configurable separators, word-boundary truncation, and collision-aware uniqueness.'
  spec.homepage = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-slug'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/philiprehberger/rb-slug'
  spec.metadata['changelog_uri'] = 'https://github.com/philiprehberger/rb-slug/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/philiprehberger/rb-slug/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
