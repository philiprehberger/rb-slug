# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.7.0] - 2026-04-30

### Added
- `Slug.swap_separator(slug, from:, to:)` — replace separator characters in an existing slug, collapsing duplicates introduced by the swap and trimming leading/trailing separators. Pairs with `detect_separator`.

## [0.6.0] - 2026-04-24

### Added
- `Slug.join(*parts, separator: '-')` — joins multiple slug parts into one slug, collapsing duplicate separators and trimming leading/trailing separators; nil and empty parts are skipped

## [0.5.0] - 2026-04-19

### Added
- `Slug.detect_separator(str)` — returns `:dash`, `:underscore`, or `nil` based on separator frequency; useful for auto-detecting separator before calling `humanize`/`valid_slug?`

## [0.4.0] - 2026-04-15

### Added
- `Slug.parameterize` — Rails-compatible alias for `generate`

## [0.3.0] - 2026-04-13

### Added
- `Slug.valid_slug?(string, separator:)` method for validating well-formed slugs
- `Slug.humanize(slug, separator:, capitalize:)` method for converting slugs back to human-readable titles

### Changed
- Optimize transliteration with pre-compiled regex instead of char-by-char iteration
- Remove unused `mapping_regex` private method from Transliterator
- Tighten RuboCop metrics to match guide defaults

## [0.2.0] - 2026-04-01

### Added
- `Slug.generate_batch(strings)` for batch slug generation with automatic deduplication
- `custom_mapping:` parameter for custom character replacements in `generate`, `transliterate`, and `generate_batch`

## [0.1.11] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.10] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.9] - 2026-03-26

### Changed
- Add Sponsor badge to README
- Fix License section format


## [0.1.8] - 2026-03-24

### Changed
- Expand README API table to document all public methods

## [0.1.7] - 2026-03-24

### Fixed
- Remove inline comments from Development section to match template

## [0.1.6] - 2026-03-23

### Fixed
- Standardize README description to match template guide
- Update gemspec summary to match README description

## [0.1.5] - 2026-03-22

### Changed
- Expand test coverage from 21 to 34 examples

## [0.1.5] - 2026-03-21

### Fixed
- Standardize Installation section in README

## [0.1.4] - 2026-03-18

### Changed
- Revert gemspec to single-quoted strings per RuboCop default configuration

## [0.1.3] - 2026-03-18

### Fixed
- Fix RuboCop Style/StringLiterals violations in gemspec

## [0.1.2] - 2026-03-16

### Added
- Add License badge to README
- Add bug_tracker_uri to gemspec

## [0.1.1] - 2026-03-15

### Added
- Add Requirements section to README

## [0.1.0] - 2026-03-15

### Added
- Initial release
- URL-friendly slug generation from any string
- Unicode to ASCII transliteration for Latin Cyrillic and Greek
- Configurable separators and word-boundary truncation
- Collision-aware uniqueness callback
