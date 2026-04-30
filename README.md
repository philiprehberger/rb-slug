# philiprehberger-slug

[![Tests](https://github.com/philiprehberger/rb-slug/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-slug/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-slug.svg)](https://rubygems.org/gems/philiprehberger-slug)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-slug)](https://github.com/philiprehberger/rb-slug/commits/main)

URL-friendly slug generator with Unicode transliteration and collision-aware uniqueness

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-slug"
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

### Batch Generation

Generate unique slugs for multiple strings with automatic deduplication:

```ruby
Philiprehberger::Slug.generate_batch(%w[Hello Hello Hello])
# => ["hello", "hello-2", "hello-3"]

Philiprehberger::Slug.generate_batch(["My Post", "Another Post", "My Post"])
# => ["my-post", "another-post", "my-post-2"]
```

### Custom Character Mapping

Override or extend the default transliteration with custom character replacements:

```ruby
Philiprehberger::Slug.generate("Hello & World", custom_mapping: { "&" => "and" })
# => "hello-and-world"
```

### Validation

Check whether a string is already a well-formed slug:

```ruby
Philiprehberger::Slug.valid_slug?("hello-world")   # => true
Philiprehberger::Slug.valid_slug?("Hello World")    # => false
Philiprehberger::Slug.valid_slug?("hello--world")   # => false
```

### Humanize

Convert a slug back to a human-readable title:

```ruby
Philiprehberger::Slug.humanize("hello-world")                       # => "Hello World"
Philiprehberger::Slug.humanize("hello-world", capitalize: :first)   # => "Hello world"
Philiprehberger::Slug.humanize("hello_world", separator: "_")       # => "Hello World"
```

### Join

Combine pre-slugged parts into one slug, collapsing duplicate separators:

```ruby
Philiprehberger::Slug.join("user", "jane-doe", "42")       # => "user-jane-doe-42"
Philiprehberger::Slug.join("-foo-", "-bar-")               # => "foo-bar"
Philiprehberger::Slug.join("foo", nil, "", "bar")          # => "foo-bar"
Philiprehberger::Slug.join("a", "b", "c", separator: "_")  # => "a_b_c"
```

### Detect separator

```ruby
Philiprehberger::Slug.detect_separator("hello-world") # => :dash
Philiprehberger::Slug.detect_separator("hello_world") # => :underscore
Philiprehberger::Slug.detect_separator("plain")       # => nil
```

### Swap separator

Replace separator characters in an existing slug, collapsing any duplicates
introduced by the swap and trimming leading/trailing separators. Pairs with
`detect_separator`.

```ruby
Philiprehberger::Slug.swap_separator("hello-world-foo", from: "-", to: "_")
# => "hello_world_foo"

Philiprehberger::Slug.swap_separator("a--b---c", from: "-", to: "_")
# => "a_b_c"
```

### Transliteration

```ruby
Philiprehberger::Slug.transliterate("café résumé")  # => "cafe resume"
```

### Rails-compatible Alias

For callers familiar with `ActiveSupport::Inflector#parameterize`:

```ruby
Philiprehberger::Slug.parameterize("Hello World!")  # => "hello-world"
```

## API

| Method | Description |
|--------|-------------|
| `Slug.generate(string, separator:, max:, unique:, custom_mapping:)` | Generate a URL-safe slug from any string |
| `Slug.parameterize(string, separator:, max:, custom_mapping:)` | Rails-compatible alias for `generate` |
| `Slug.generate_batch(strings, separator:, max:, custom_mapping:)` | Generate unique slugs for an array of strings with deduplication |
| `Slug.valid_slug?(string, separator:)` | Check whether a string is a well-formed slug |
| `Slug.humanize(slug, separator:, capitalize:)` | Convert a slug back to a human-readable title |
| `Slug.join(*parts, separator:)` | Join slug parts into one slug, collapsing duplicate separators |
| `Slug.detect_separator(string)` | Detect the dominant separator (`:dash`, `:underscore`, or `nil`) in a string |
| `Slug.swap_separator(slug, from:, to:)` | Replace `from` separator with `to` in a slug, collapsing duplicates and trimming edges |
| `Slug.transliterate(string, custom_mapping:)` | Transliterate Unicode characters to ASCII equivalents |
| `Slug::Error` | Error raised for invalid input (e.g. non-String argument) |
| `Slug::VERSION` | Current gem version string |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-slug)

🐛 [Report issues](https://github.com/philiprehberger/rb-slug/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-slug/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
