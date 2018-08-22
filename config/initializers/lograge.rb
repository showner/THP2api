Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.logger = ActiveSupport::Logger.new(STDOUT)

  config.logger = LogStashLogger.new(type: :stdout)

  Rack::Timeout::StateChangeLoggingObserver::STATE_LOG_LEVEL[:ready] = :debug
  Rack::Timeout::StateChangeLoggingObserver::STATE_LOG_LEVEL[:completed] = :debug
  Rack::Timeout::Logger.logger = config.logger
end
