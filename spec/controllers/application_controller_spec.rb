require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "OK"
    end
  end

  before do
    routes.draw do
      get "index" => "anonymous#index"
      get "moon" => "anonymous#moon"
      get "sun" => "anonymous#sun"
      root to: "anonymous#index"
    end
  end

  describe "moon action" do
    it "sets the moon cookie and redirects to root" do
      get :moon

      expect(cookies[:moon]).to eq("dark mode on")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "sun action" do
    before do
      cookies[:moon] = "dark mode on"
    end

    it "removes the moon cookie and redirects to root" do
      get :sun

      expect(cookies[:moon]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  describe "before_action :set_theme" do
    let(:theme_resolver) { instance_double(Themes::ThemeResolver) }

    before do
      allow(Themes::ThemeResolver).to receive(:new)
        .and_return(theme_resolver)

      allow(theme_resolver).to receive(:resolve)
        .and_return(:dark)
    end

    it "resolves and assigns the theme" do
      get :index

      expect(Themes::ThemeResolver).to have_received(:new) do |user:, request:|
        expect(user).to eq(controller.current_user)
        expect(request).to be_a(ActionDispatch::Request)
      end

      expect(theme_resolver).to have_received(:resolve)
      expect(assigns(:theme)).to eq(:dark)
    end
  end

  describe "#current_user" do
    it "returns an admin user with flipper_id" do
      user = controller.current_user

      expect(user.admin?).to be true
      expect(user.flipper_id).to be_present
    end
  end
end
