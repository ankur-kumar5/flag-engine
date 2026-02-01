class Theme
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def layout
    config.fetch("layout")
  end

  def stylesheet
    "themes/#{name}"
  end

  private

  def config
    @config ||= Rails.application.config_for(:themes).fetch(name)
  end
end
