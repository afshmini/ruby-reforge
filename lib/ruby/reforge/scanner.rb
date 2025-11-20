# frozen_string_literal: true

require "prism"
require "find"

module Ruby
  module Reforge
    class Scanner
      def initialize(root_path)
        @root_path = root_path
        @issues = []
      end

      def scan(target_version)
        @target_version = normalize_version(target_version)
        @issues = []

        # Get migration rules for target version
        rules = MigrationRules.for_version(@target_version)

        # Add Rails rules if Rails project detected
        if RailsRules.detect_rails_project?(@root_path)
          rules = merge_rails_rules(rules)
        end

        # Scan Ruby files
        scan_ruby_files(rules)

        @issues
      end

      private

      def scan_ruby_files(rules)
        ruby_files.each do |file_path|
          begin
            content = File.read(file_path)
            parse_result = Prism.parse(content, file_path)

            if parse_result.success?
              scan_ast(parse_result.value, file_path, rules)
            else
              # File has syntax errors, but we can still scan for patterns
              scan_file_content(content, file_path, rules)
            end
          rescue => e
            # Skip files that can't be parsed
            next
          end
        end
      end

      def scan_ast(node, file_path, rules)
        # Scan for keyword argument issues (Ruby 3.0+)
        if @target_version >= "3.0.0"
          scan_keyword_arguments(node, file_path)
        end

        # Scan for deprecated method calls
        scan_deprecated_methods(node, file_path, rules)

        # Recursively scan child nodes
        node.child_nodes.each do |child|
          scan_ast(child, file_path, rules) if child.respond_to?(:child_nodes)
        end
      end

      def scan_keyword_arguments(node, file_path)
        # Detect method definitions that might need **args
        if node.is_a?(Prism::DefNode)
          # Check if method accepts keyword arguments without **
          # This is a simplified check - real implementation would be more sophisticated
        end
      end

      def scan_deprecated_methods(node, file_path, rules)
        rules.deprecated_methods.each do |deprecated_method, replacement|
          if node.is_a?(Prism::CallNode) && node.name == deprecated_method.to_sym
            @issues << Issue.new(
              type: :deprecated_method,
              file: file_path,
              line: node.location.start_line,
              message: "#{deprecated_method} is deprecated, use #{replacement} instead",
              old_code: deprecated_method.to_s,
              new_code: replacement.to_s
            )
          end
        end
      end

      def scan_file_content(content, file_path, rules)
        lines = content.lines

        rules.deprecated_patterns.each do |pattern, replacement|
          lines.each_with_index do |line, index|
            if line.match?(pattern)
              # Preserve indentation when replacing
              indent = line[/\A\s*/]
              new_line = line.gsub(pattern, replacement)
              # Ensure new line ends properly
              new_line = new_line.chomp + "\n" unless new_line.end_with?("\n")
              
              @issues << Issue.new(
                type: :deprecated_pattern,
                file: file_path,
                line: index + 1,
                message: "Deprecated pattern found: #{pattern.source}",
                old_code: line,
                new_code: new_line
              )
            end
          end
        end
      end


      def ruby_files
        @ruby_files ||= begin
          files = []
          Find.find(@root_path) do |path|
            next if File.directory?(path)
            next if path.include?("/vendor/")
            next if path.include?("/node_modules/")
            next if path.include?("/.git/")
            next if path.include?("/tmp/")
            next if path.include?("/log/")

            files << path if path.end_with?(".rb")
          end
          files
        end
      end

      def normalize_version(version)
        parts = version.to_s.split(".").map(&:to_i)
        parts << 0 while parts.size < 3
        parts[0..2].join(".")
      end

      def merge_rails_rules(rules)
        # Merge Rails deprecations into existing rules
        merged_methods = rules.deprecated_methods.merge(RailsRules.deprecated_methods)
        merged_patterns = rules.deprecated_patterns.merge(RailsRules.deprecated_patterns)
        
        merged_rules = MigrationRules.new
        merged_rules.instance_variable_set(:@deprecated_methods, merged_methods)
        merged_rules.instance_variable_set(:@deprecated_patterns, merged_patterns)
        merged_rules.instance_variable_set(:@breaking_changes, rules.breaking_changes)
        merged_rules
      end
    end

    class Issue
      attr_reader :type, :file, :line, :message, :old_code, :new_code

      def initialize(type:, file:, line:, message:, old_code: nil, new_code: nil)
        @type = type
        @file = file
        @line = line
        @message = message
        @old_code = old_code
        @new_code = new_code
      end

      def severity
        case @type
        when :deprecated_method, :deprecated_pattern
          :warning
        when :breaking_change
          :error
        else
          :info
        end
      end
    end
  end
end

