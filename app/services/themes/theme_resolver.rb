module Themes
  class ThemeResolver

    THEMES_MODES = {
        light: "light",
        dark: "dark"
    }.freeze

    def initialize(user:, request:)
      @user = user
      @request = request
    end

    def resolve
      return get_theme if @user&.admin? && Flipper.enabled?(:dark_mode, @user)

      default_theme
    end

    def get_theme
    return Theme.new(THEMES_MODES[:dark]) if @request.cookies['moon'].present?

    default_theme
    end

    def default_theme
      Theme.new(THEMES_MODES[:light])
    end
  end
end
