# frozen_string_literal: true

require "thor"
require "rainbow"
require "tty-prompt"

module Ruby
  module Reforge
    class CLI < Thor
      include Thor::Actions

      desc "upgrade VERSION", "Upgrade Ruby project to target version"
      option :interactive, type: :boolean, aliases: "-i", desc: "Interactive mode - prompts before changes"
      option :dry_run, type: :boolean, aliases: "-d", desc: "Show what would be changed without making changes"
      option :branch, type: :string, desc: "Git branch name (default: upgrade/ruby-VERSION)"
      def upgrade(version)
        say "🚀 Ruby Reforge - Upgrading to Ruby #{version}", :green
        say ""

        target_version = normalize_version(version)
        current_version = detect_current_ruby_version

        if current_version == target_version
          say "✓ Already on Ruby #{target_version}", :green
          exit 0
        end

        say "Current Ruby version: #{current_version || 'unknown'}", :yellow
        say "Target Ruby version: #{target_version}", :yellow
        say ""

        # Create git branch if in git repo
        if git_integration.available?
          branch_name = options[:branch] || "upgrade/ruby-#{target_version}"
          git_integration.create_branch(branch_name) unless options[:dry_run]
        end

        # Scan for issues
        say "🔍 Scanning codebase...", :cyan
        issues = scanner.scan(target_version)

        # Generate report
        reporter.report(issues, current_version, target_version)

        if options[:dry_run]
          say "\n🔍 DRY RUN - No changes made", :yellow
          exit 0
        end

        # Interactive mode
        if options[:interactive]
          prompt = TTY::Prompt.new
          unless prompt.yes?("Proceed with automatic fixes?")
            say "Aborted.", :red
            exit 0
          end
        end

        # Update version files
        say "\n📝 Updating version files...", :cyan
        version_updater.update(target_version)

        # Apply fixes
        say "\n🔧 Applying fixes...", :cyan
        rewriter.rewrite(issues, interactive: options[:interactive])

        # Commit changes
        if git_integration.available? && !options[:dry_run]
          git_integration.commit_version_files
          git_integration.commit_code_changes
        end

        say "\n✅ Upgrade complete!", :green
        say "\nNext steps:"
        say "  1. Review the changes"
        say "  2. Run your test suite"
        say "  3. Update dependencies: bundle update"
        say "  4. Check for any manual fixes needed"
      end

      desc "report", "Generate a report of deprecated code and upgrade issues"
      option :target, type: :string, desc: "Target Ruby version (default: latest stable)"
      def report
        say "📊 Ruby Reforge - Generating Report", :green
        say ""

        current_version = detect_current_ruby_version
        target_version = options[:target] ? normalize_version(options[:target]) : "3.3.0"

        say "Current Ruby version: #{current_version || 'unknown'}", :yellow
        say "Target Ruby version: #{target_version}", :yellow
        say ""

        say "🔍 Scanning codebase...", :cyan
        issues = scanner.scan(target_version)

        reporter.report(issues, current_version, target_version)
      end

      desc "ai-fix", "Use AI to fix complex deprecated code (experimental)"
      option :model, type: :string, default: "local", desc: "AI model to use (local, openai, anthropic)"
      def ai_fix
        say "🤖 AI-Assisted Fix Mode (Experimental)", :green
        say "This feature is coming soon!", :yellow
      end

      private

      def normalize_version(version)
        # Normalize version string (e.g., "3.3" -> "3.3.0")
        parts = version.split(".").map(&:to_i)
        parts << 0 while parts.size < 3
        parts[0..2].join(".")
      end

      def detect_current_ruby_version
        version_updater.detect_current_version
      end

      def scanner
        @scanner ||= Scanner.new(source_root)
      end

      def rewriter
        @rewriter ||= Rewriter.new(source_root)
      end

      def version_updater
        @version_updater ||= VersionUpdater.new(source_root)
      end

      def reporter
        @reporter ||= Reporter.new
      end

      def git_integration
        @git_integration ||= GitIntegration.new(source_root)
      end

      def source_root
        @source_root ||= Dir.pwd
      end
    end
  end
end

