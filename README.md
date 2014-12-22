# philiprehberger-slug

[![Tests](https://github.com/philiprehberger/rb-slug/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-slug/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-slug.svg)](https://rubygems.org/gems/philiprehberger-slug)
[![License](https://img.shields.io/github/license/philiprehberger/rb-slug)](LICENSE)

URL-friendly slug generator with Unicode transliteration, configurable separators, word-boundary truncation, and collision-aware uniqueness.

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-slug"
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install philiprehberger-slug
```

## Usage

```ruby
require "philiprehberger/slug"

Philiprehberger::Slug.generate("Hello World!")        # => "hello-world"
Philiprehberger::Slug.generate("Héllo Wörld")         # => "hello-world"
Philiprehberger::Slug.generate("Привет мир")          # => "privet-mir"
```

### Custom Separator

```ruby
Philiprehberger::Slug.generate("Hello World", separator: "_")  # => "hello_world"
```

### Max Length

Truncates at the nearest word boundary:

```ruby
Philiprehberger::Slug.generate("Hello Beautiful World", max: 16)  # => "hello-beautiful"
```

### Uniqueness

Pass a callable that returns `true` if the slug already exists:

```ruby
Philiprehberger::Slug.generate("My Post", unique: ->(s) { Post.exists?(slug: s) })
# => "my-post" or "my-post-2" if "my-post" exists
```

### Transliteration

```ruby
Philiprehberger::Slug.transliterate("café résumé")  # => "cafe resume"
```

## API

| Method | Description |
|--------|-------------|
| `Slug.generate(string, separator: "-", max: nil, unique: nil)` | Generate a URL-safe slug |
| `Slug.transliterate(string)` | Unicode to ASCII transliteration |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

MIT
