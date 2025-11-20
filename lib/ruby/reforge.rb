# frozen_string_literal: true

require_relative "reforge/version"
require_relative "reforge/cli"
require_relative "reforge/scanner"
require_relative "reforge/rewriter"
require_relative "reforge/version_updater"
require_relative "reforge/migration_rules"
require_relative "reforge/rails_rules"
require_relative "reforge/reporter"
require_relative "reforge/git_integration"

module Ruby
  module Reforge
    class Error < StandardError; end
  end
end

