# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require "fileutils"

RSpec.describe Ruby::Reforge::VersionUpdater do
  let(:tmpdir) { Dir.mktmpdir }
  let(:updater) { described_class.new(tmpdir) }

  after do
    FileUtils.rm_rf(tmpdir)
  end

  describe "#detect_current_version" do
    context "when .ruby-version exists" do
      before do
        File.write(File.join(tmpdir, ".ruby-version"), "3.1.0\n")
      end

      it "returns the version from .ruby-version" do
        expect(updater.detect_current_version).to eq("3.1.0")
      end
    end

    context "when Gemfile exists with ruby version" do
      before do
        File.write(File.join(tmpdir, "Gemfile"), "source 'https://rubygems.org'\nruby '3.0.0'\n")
      end

      it "returns the version from Gemfile" do
        expect(updater.detect_current_version).to eq("3.0.0")
      end
    end

    context "when no version file exists" do
      it "returns nil" do
        expect(updater.detect_current_version).to be_nil
      end
    end
  end

  describe "#update" do
    it "updates .ruby-version file" do
      ruby_version_path = File.join(tmpdir, ".ruby-version")
      File.write(ruby_version_path, "3.0.0\n")

      updater.update("3.3.0")

      expect(File.read(ruby_version_path)).to eq("3.3.0\n")
    end

    it "updates Gemfile ruby version" do
      gemfile_path = File.join(tmpdir, "Gemfile")
      File.write(gemfile_path, "source 'https://rubygems.org'\nruby '3.0.0'\n")

      updater.update("3.3.0")

      expect(File.read(gemfile_path)).to include("ruby '3.3.0'")
    end
  end
end

