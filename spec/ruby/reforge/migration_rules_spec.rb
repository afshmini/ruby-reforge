# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ruby::Reforge::MigrationRules do
  describe ".for_version" do
    it "returns rules for Ruby 3.0.0" do
      rules = described_class.for_version("3.0.0")
      expect(rules.deprecated_methods).to include("File.exists?" => "File.exist?")
    end

    it "returns rules for Ruby 3.3.0" do
      rules = described_class.for_version("3.3.0")
      expect(rules.deprecated_methods).to include("File.exists?" => "File.exist?")
    end
  end

  describe ".normalize_version" do
    it "normalizes version strings" do
      expect(described_class.normalize_version("3.1")).to eq("3.1.0")
      expect(described_class.normalize_version("3.1.5")).to eq("3.1.5")
    end
  end
end

