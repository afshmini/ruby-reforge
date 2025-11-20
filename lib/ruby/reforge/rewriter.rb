# frozen_string_literal: true

require "fileutils"

module Ruby
  module Reforge
    class Rewriter
      def initialize(root_path)
        @root_path = root_path
      end

      def rewrite(issues, interactive: false)
        grouped_issues = issues.group_by(&:file)
        fixed_count = 0

        grouped_issues.each do |file_path, file_issues|
          next unless File.exist?(file_path)

          content = File.read(file_path)
          lines = content.lines
          modified = false

          # Sort issues by line number (descending) to avoid offset issues
          file_issues.sort_by { |i| -i.line }.each do |issue|
            case issue.type
            when :deprecated_method, :deprecated_pattern
              if interactive
                next unless confirm_fix?(issue)
              end

              line_index = issue.line - 1
              if line_index < lines.length
                old_line = lines[line_index]
                new_line = apply_fix(old_line, issue)
                if old_line != new_line
                  lines[line_index] = new_line
                  modified = true
                  fixed_count += 1
                end
              end
            end
          end

          if modified
            File.write(file_path, lines.join)
            say "✓ Fixed #{file_issues.size} issue(s) in #{File.basename(file_path)}", :green
          end
        end

        fixed_count
      end

      private

      def apply_fix(line, issue)
        case issue.type
        when :deprecated_method
          # Replace deprecated method calls
          if issue.old_code && issue.new_code
            # Try exact match first
            if line.include?(issue.old_code)
              line.gsub(issue.old_code, issue.new_code)
            else
              # Try with method call syntax
              line.gsub(/#{Regexp.escape(issue.old_code)}/, issue.new_code)
            end
          else
            line
          end
        when :deprecated_pattern
          # Apply pattern-based fixes - use the new_code which should be the replacement
          # The issue.new_code contains the full line replacement
          if issue.new_code
            issue.new_code
          else
            line
          end
        else
          line
        end
      end

      def confirm_fix?(issue)
        require "tty-prompt"
        prompt = TTY::Prompt.new
        prompt.yes?("Fix: #{issue.message} at #{File.basename(issue.file)}:#{issue.line}?")
      end

      def say(message, color = nil)
        require "rainbow"
        Rainbow.enabled = true
        if color && !color.to_s.empty?
          output = Rainbow(message).color(color)
        else
          output = message
        end
        puts output
      end
    end
  end
end

