Rollbar.configure do |config|
  config.access_token = Rails.application.credentials.dig(:rollbar, :access_token)

  if Rails.env.test? || Rails.env.development?
    config.enabled = false
  end

  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
end
