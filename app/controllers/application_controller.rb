class ApplicationController < ActionController::Base
  before_action :set_theme
  helper_method :current_user

  def moon
    cookies[:moon] = {
      value: 'dark mode on'
    }
    redirect_to root_path
  end

  def sun
    cookies.delete(:moon)
    redirect_to root_path
  end

  def current_user
    # sample user
    @current_user ||= OpenStruct.new(id: 1, flipper_id: 1, name: "My App Admin", admin?: true)
  end

  private

  def set_theme
    resolver = Themes::ThemeResolver.new(
      user: current_user,
      request: request
    )

    @theme = resolver.resolve
  end
end
