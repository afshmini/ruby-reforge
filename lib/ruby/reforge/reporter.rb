# frozen_string_literal: true

require "rainbow"

module Ruby
  module Reforge
    class Reporter
      def report(issues, current_version, target_version)
        say "\n" + "=" * 80, :cyan
        say "📊 Upgrade Report: Ruby #{current_version || 'unknown'} → #{target_version}", :cyan
        say "=" * 80, :cyan
        say ""

        if issues.empty?
          say "✅ No issues found! Your code is ready for Ruby #{target_version}.", :green
          return
        end

        # Group issues by type
        by_type = issues.group_by(&:type)
        by_severity = issues.group_by(&:severity)

        # Summary
        say "Summary:", :yellow
        say "  Total issues found: #{issues.size}", :white
        say "  Errors: #{by_severity[:error]&.size || 0}", :red
        say "  Warnings: #{by_severity[:warning]&.size || 0}", :yellow
        say "  Info: #{by_severity[:info]&.size || 0}", :blue
        say ""

        # Issues by file
        by_file = issues.group_by(&:file)
        say "Issues by file:", :yellow
        say ""

        by_file.each do |file, file_issues|
          relative_path = file.start_with?("/") ? file : file
          say "  #{relative_path} (#{file_issues.size} issue(s))", :white
          file_issues.each do |issue|
            severity_color = case issue.severity
            when :error then :red
            when :warning then :yellow
            else :blue
            end

            say "    Line #{issue.line}: #{issue.message}", severity_color
            if issue.old_code && issue.new_code
              say "      Old: #{issue.old_code}", :red
              say "      New: #{issue.new_code}", :green
            end
          end
          say ""
        end

        # Breaking changes
        if by_type[:breaking_change]
          say "⚠️  Breaking Changes:", :red
          by_type[:breaking_change].each do |issue|
            say "  - #{issue.message}", :red
          end
          say ""
        end

        # Recommendations
        say "Recommendations:", :yellow
        say "  1. Review all deprecated method calls", :white
        say "  2. Test thoroughly after applying fixes", :white
        say "  3. Update dependencies: bundle update", :white
        say "  4. Check for gem compatibility with Ruby #{target_version}", :white
        say ""

        say "Run 'ruby-reforge upgrade #{target_version}' to apply automatic fixes.", :green
      end

      private

      def say(message, color = nil)
        puts Rainbow(message).color(color)
      end
    end
  end
end

