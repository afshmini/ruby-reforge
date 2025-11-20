# frozen_string_literal: true

module Ruby
  module Reforge
    class RailsRules
      RAILS_DEPRECATIONS = {
        "before_filter" => "before_action",
        "after_filter" => "after_action",
        "around_filter" => "around_action",
        "skip_before_filter" => "skip_before_action",
        "skip_after_filter" => "skip_after_action",
        "skip_around_filter" => "skip_around_action",
        "update_attributes" => "update",
        "update_attributes!" => "update!",
        "render :text" => "render plain:",
        "render :nothing" => "head :ok"
      }.freeze

      RAILS_PATTERNS = {
        /before_filter/ => "before_action",
        /after_filter/ => "after_action",
        /around_filter/ => "around_action",
        /skip_before_filter/ => "skip_before_action",
        /skip_after_filter/ => "skip_after_action",
        /skip_around_filter/ => "skip_around_action",
        /\.update_attributes\(/ => ".update(",
        /\.update_attributes!/ => ".update!",
        /render\s+:text\s*=>/ => "render plain:",
        /render\s+:nothing/ => "head :ok"
      }.freeze

      def self.deprecated_methods
        RAILS_DEPRECATIONS
      end

      def self.deprecated_patterns
        RAILS_PATTERNS
      end

      def self.detect_rails_project?(root_path)
        File.exist?(File.join(root_path, "config", "application.rb")) ||
          File.exist?(File.join(root_path, "Gemfile")) && File.read(File.join(root_path, "Gemfile")).include?("rails")
      end
    end
  end
end

