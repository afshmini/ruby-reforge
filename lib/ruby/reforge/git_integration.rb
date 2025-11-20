# frozen_string_literal: true

require "fileutils"

module Ruby
  module Reforge
    class GitIntegration
      def initialize(root_path)
        @root_path = root_path
      end

      def available?
        git_dir = File.join(@root_path, ".git")
        File.directory?(git_dir) && system("git --version > /dev/null 2>&1")
      end

      def create_branch(branch_name)
        return unless available?

        system("cd #{@root_path} && git checkout -b #{branch_name} 2>/dev/null") ||
          system("cd #{@root_path} && git checkout #{branch_name} 2>/dev/null")
      end

      def commit_version_files
        return unless available?

        files = [".ruby-version", "Gemfile"]
        files += Dir.glob(File.join(@root_path, "**/*.gemspec"))

        staged_files = files.select { |f| File.exist?(File.join(@root_path, f)) }
        return if staged_files.empty?

        system("cd #{@root_path} && git add #{staged_files.join(' ')}")
        system("cd #{@root_path} && git commit -m 'chore: update Ruby version files'")
      end

      def commit_code_changes
        return unless available?

        # Get list of modified Ruby files
        modified = `cd #{@root_path} && git diff --name-only --diff-filter=M`.split("\n")
        ruby_files = modified.select { |f| f.end_with?(".rb") }

        return if ruby_files.empty?

        system("cd #{@root_path} && git add #{ruby_files.join(' ')}")
        system("cd #{@root_path} && git commit -m 'fix: update deprecated Ruby syntax'")
      end
    end
  end
end

