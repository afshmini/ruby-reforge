# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2024-01-XX

### Fixed
- Fixed Rainbow color error when outputting messages without colors (nil color handling)
- Fixed reporter and rewriter to properly handle empty color parameters

## [0.1.0] - 2024-01-XX

### Added
- Initial release
- CLI interface with `upgrade`, `report`, and `ai-fix` commands
- Automatic version file updates (`.ruby-version`, `Gemfile`, `gemspec`)
- Code scanner using Prism for AST parsing
- Migration rules for Ruby 3.0, 3.1, 3.2, and 3.3
- Rails-specific deprecation rules
- Interactive mode for reviewing changes
- Dry-run mode
- Git integration (branch creation and commits)
- Detailed reporting with colorized output

### Features
- Detects and fixes deprecated methods (`File.exists?`, `Dir.exists?`, etc.)
- Pattern-based code rewriting
- Rails filter to action migrations
- Comprehensive upgrade reports

