require "rails_helper"

RSpec.describe Themes::ThemeResolver do
  let(:request) { instance_double(ActionDispatch::Request, cookies: cookies) }
  let(:cookies) { {} }

  let(:admin_user) do
    OpenStruct.new(
      id: 1,
      flipper_id: "User:1",
      admin?: true
    )
  end

  let(:non_admin_user) do
    OpenStruct.new(
      id: 2,
      flipper_id: "User:2",
      admin?: false
    )
  end

  subject(:resolver) do
    described_class.new(user: user, request: request)
  end

  before do
    allow(Flipper).to receive(:enabled?)
      .with(:dark_mode, admin_user)
      .and_return(flipper_enabled)
  end

  describe "#resolve" do
    context "when user is admin and flipper is enabled and moon cookie is present" do
      let(:user) { admin_user }
      let(:flipper_enabled) { true }
      let(:cookies) { { "moon" => "dark mode on" } }

      it "returns dark theme" do
        theme = resolver.resolve

        expect(theme).to be_a(Theme)
        expect(theme.name).to eq("dark")
      end
    end

    context "when user is admin and flipper is enabled but moon cookie is missing" do
      let(:user) { admin_user }
      let(:flipper_enabled) { true }

      it "returns light theme" do
        theme = resolver.resolve

        expect(theme.name).to eq("light")
      end
    end

    context "when user is admin but flipper is disabled" do
      let(:user) { admin_user }
      let(:flipper_enabled) { false }
      let(:cookies) { { "moon" => "dark mode on" } }

      it "returns light theme" do
        theme = resolver.resolve

        expect(theme.name).to eq("light")
      end
    end

    context "when user is not admin" do
      let(:user) { non_admin_user }
      let(:flipper_enabled) { true }

      it "returns light theme" do
        theme = resolver.resolve

        expect(theme.name).to eq("light")
      end
    end

    context "when user is nil" do
      let(:user) { nil }
      let(:flipper_enabled) { false }

      it "returns light theme" do
        theme = resolver.resolve

        expect(theme.name).to eq("light")
      end
    end
  end
end
