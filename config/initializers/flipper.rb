require 'flipper/adapters/redis'

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::Redis.new(
      Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
    )
    Flipper.new(adapter)
  end
end
