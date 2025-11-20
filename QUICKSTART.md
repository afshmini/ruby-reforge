# Quick Start Guide

## Building the Gem

```bash
cd ruby-reforge
gem build ruby-reforge.gemspec
```

This will create a `ruby-reforge-0.1.0.gem` file.

## Installing Locally

```bash
gem install ./ruby-reforge-0.1.0.gem
```

Or install from the local directory:

```bash
bundle install
bundle exec ruby-reforge --help
```

## Development Setup

```bash
bundle install
bundle exec rspec  # Run tests
```

## Usage Examples

### Generate a report

```bash
ruby-reforge report
```

### Upgrade to Ruby 3.3

```bash
ruby-reforge upgrade 3.3
```

### Interactive mode

```bash
ruby-reforge upgrade 3.3 --interactive
```

### Dry run (see what would change)

```bash
ruby-reforge upgrade 3.3 --dry-run
```

## Project Structure

```
ruby-reforge/
├── lib/
│   └── ruby/
│       └── reforge/
│           ├── cli.rb              # CLI interface
│           ├── scanner.rb          # Code scanner
│           ├── rewriter.rb         # Code rewriter
│           ├── version_updater.rb  # Version file updates
│           ├── migration_rules.rb  # Ruby version rules
│           ├── rails_rules.rb      # Rails-specific rules
│           ├── reporter.rb         # Report generator
│           └── git_integration.rb  # Git operations
├── exe/
│   └── ruby-reforge            # Executable
├── spec/                          # Tests
└── ruby-reforge.gemspec        # Gem specification
```
