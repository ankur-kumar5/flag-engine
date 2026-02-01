require "rails_helper"

RSpec.describe Theme do
  let(:theme_name) { "light" }
  subject(:theme) { described_class.new(theme_name) }

  describe "#initialize" do
    it "sets the theme name" do
      expect(theme.name).to eq("light")
    end
  end

  describe "#stylesheet" do
    it "returns the correct stylesheet path" do
      expect(theme.stylesheet).to eq("themes/light")
    end
  end

  describe "#layout" do
    let(:themes_config) do
      {
        "light" => { "layout" => "application" },
        "dark" => { "layout" => "dark_application" }
      }
    end

    before do
      allow(Rails.application)
        .to receive(:config_for)
        .with(:themes)
        .and_return(themes_config)
    end

    it "returns the layout from config" do
      expect(theme.layout).to eq("application")
    end
  end

  describe "config memoization" do
    let(:themes_config) do
      {
        "light" => { "layout" => "application" }
      }
    end

    it "loads config only once" do
      expect(Rails.application)
        .to receive(:config_for)
        .once
        .with(:themes)
        .and_return(themes_config)

      theme.layout
      theme.layout # second call should use memoized config
    end
  end
end
