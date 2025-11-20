# frozen_string_literal: true

module Ruby
  module Reforge
    class MigrationRules
      RULES = {
        "3.0.0" => {
          deprecated_methods: {
            "File.exists?" => "File.exist?",
            "Dir.exists?" => "Dir.exist?",
            "URI.escape" => "CGI.escape",
            "URI.unescape" => "CGI.unescape"
          },
          deprecated_patterns: {
            /File\.exists\?/ => "File.exist?",
            /Dir\.exists\?/ => "Dir.exist?",
            /URI\.escape/ => "CGI.escape",
            /URI\.unescape/ => "CGI.unescape"
          },
          breaking_changes: [
            "Keyword arguments are now separated from positional arguments"
          ]
        },
        "3.1.0" => {
          deprecated_methods: {
            "File.exists?" => "File.exist?",
            "Dir.exists?" => "Dir.exist?"
          },
          deprecated_patterns: {
            /File\.exists\?/ => "File.exist?",
            /Dir\.exists\?/ => "Dir.exist?"
          }
        },
        "3.2.0" => {
          deprecated_methods: {
            "File.exists?" => "File.exist?",
            "Dir.exists?" => "Dir.exist?"
          },
          deprecated_patterns: {
            /File\.exists\?/ => "File.exist?",
            /Dir\.exists\?/ => "Dir.exist?"
          }
        },
        "3.3.0" => {
          deprecated_methods: {
            "File.exists?" => "File.exist?",
            "Dir.exists?" => "Dir.exist?"
          },
          deprecated_patterns: {
            /File\.exists\?/ => "File.exist?",
            /Dir\.exists\?/ => "Dir.exist?"
          }
        }
      }.freeze

      def self.for_version(version)
        # Find the most appropriate rule set
        target = normalize_version(version)
        rule_key = RULES.keys.select { |k| normalize_version(k) <= target }.max || RULES.keys.first
        new(RULES[rule_key] || {})
      end

      def self.normalize_version(version)
        parts = version.to_s.split(".").map(&:to_i)
        parts << 0 while parts.size < 3
        parts[0..2].join(".")
      end

      attr_reader :deprecated_methods, :deprecated_patterns, :breaking_changes

      def initialize(rules = {})
        @deprecated_methods = rules[:deprecated_methods] || {}
        @deprecated_patterns = rules[:deprecated_patterns] || {}
        @breaking_changes = rules[:breaking_changes] || []
      end
    end
  end
end

