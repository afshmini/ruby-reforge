# Ruby Reforge

🚀 Automatically upgrade Ruby projects to newer versions and fix deprecated code.

## Overview

`ruby-reforge` is a gem that scans a Ruby or Rails project, detects incompatible code for a target Ruby version (e.g., upgrading from 3.1 → 3.3), and automatically rewrites or suggests fixes.

## Features

- ✅ Updates `.ruby-version`, `Gemfile`, and `gemspec` files
- ✅ Fixes deprecated Ruby syntax automatically
- ✅ Detects and fixes removed features
- ✅ Rewrites code for new Ruby syntax
- ✅ Generates detailed upgrade reports
- ✅ Interactive mode for reviewing changes
- ✅ Git integration (creates branches, commits changes)

## Installation

```bash
gem install ruby-reforge
```

Or add it to your Gemfile:

```ruby
gem 'ruby-reforge', group: :development
```

## Usage

### Upgrade to a new Ruby version

```bash
ruby-reforge upgrade 3.3
```

This will:
1. Update version files (`.ruby-version`, `Gemfile`, `gemspec`)
2. Scan your codebase for deprecated patterns
3. Automatically fix issues
4. Create a git branch and commit changes

### Generate a report

```bash
ruby-reforge report
```

Shows what needs to be fixed without making changes.

### Interactive mode

```bash
ruby-reforge upgrade 3.3 --interactive
```

Prompts before making each change.

### Dry run

```bash
ruby-reforge upgrade 3.3 --dry-run
```

Shows what would be changed without making any changes.

## What It Fixes

### Deprecated Methods

- `File.exists?` → `File.exist?`
- `Dir.exists?` → `Dir.exist?`
- `URI.escape` → `CGI.escape`
- And more...

### Version Files

- Updates `.ruby-version`
- Updates `Gemfile` ruby version
- Updates `gemspec` required_ruby_version

### Ruby 3.0+ Keyword Arguments

Detects and suggests fixes for keyword argument changes.

## Examples

```bash
# Upgrade to Ruby 3.3
ruby-reforge upgrade 3.3

# Generate report for Ruby 3.2
ruby-reforge report --target 3.2

# Interactive upgrade
ruby-reforge upgrade 3.3 --interactive
```

## Roadmap

- [ ] Rails-specific deprecations
- [ ] Gem dependency compatibility checker
- [ ] AI-assisted fixes for complex code
- [ ] Test framework updates
- [ ] Performance improvement suggestions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
