# frozen_string_literal: true

require "fileutils"

module Ruby
  module Reforge
    class VersionUpdater
      def initialize(root_path)
        @root_path = root_path
      end

      def update(target_version)
        updated_files = []

        # Update .ruby-version
        ruby_version_path = File.join(@root_path, ".ruby-version")
        if File.exist?(ruby_version_path)
          File.write(ruby_version_path, "#{target_version}\n")
          updated_files << ".ruby-version"
        end

        # Update Gemfile
        gemfile_path = File.join(@root_path, "Gemfile")
        if File.exist?(gemfile_path)
          update_gemfile(gemfile_path, target_version)
          updated_files << "Gemfile"
        end

        # Update gemspec files
        Dir.glob(File.join(@root_path, "**/*.gemspec")).each do |gemspec_path|
          update_gemspec(gemspec_path, target_version)
          updated_files << gemspec_path
        end

        updated_files
      end

      def detect_current_version
        # Try .ruby-version first
        ruby_version_path = File.join(@root_path, ".ruby-version")
        if File.exist?(ruby_version_path)
          version = File.read(ruby_version_path).strip
          return version if version.match?(/^\d+\.\d+\.\d+/)
        end

        # Try Gemfile
        gemfile_path = File.join(@root_path, "Gemfile")
        if File.exist?(gemfile_path)
          content = File.read(gemfile_path)
          if match = content.match(/ruby\s+['"]([\d.]+)['"]/)
            return normalize_version(match[1])
          end
        end

        # Try gemspec
        Dir.glob(File.join(@root_path, "**/*.gemspec")).each do |gemspec_path|
          content = File.read(gemspec_path)
          if match = content.match(/required_ruby_version\s*[>=<]+\s*['"]([\d.]+)['"]/)
            return normalize_version(match[1])
          end
        end

        nil
      end

      private

      def update_gemfile(gemfile_path, target_version)
        content = File.read(gemfile_path)
        updated_content = content.gsub(
          /ruby\s+['"][\d.]+['"]/,
          "ruby '#{target_version}'"
        )

        # If no ruby version specified, add it after source
        unless content.match(/ruby\s+['"][\d.]+['"]/)
          updated_content = updated_content.sub(
            /(source\s+['"][^'"]+['"])/,
            "\\1\nruby '#{target_version}'"
          )
        end

        File.write(gemfile_path, updated_content)
      end

      def update_gemspec(gemspec_path, target_version)
        content = File.read(gemspec_path)
        updated_content = content.gsub(
          /required_ruby_version\s*[>=<]+\s*['"][\d.]+['"]/,
          "required_ruby_version = \">= #{target_version}\""
        )

        # If no required_ruby_version specified, add it
        unless content.match(/required_ruby_version/)
          updated_content = updated_content.sub(
            /(spec\.version\s*=.*)/,
            "\\1\n  spec.required_ruby_version = \">= #{target_version}\""
          )
        end

        File.write(gemspec_path, updated_content)
      end

      def normalize_version(version)
        parts = version.split(".").map(&:to_i)
        parts << 0 while parts.size < 3
        parts[0..2].join(".")
      end
    end
  end
end

