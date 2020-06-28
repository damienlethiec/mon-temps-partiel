require "httparty"

module Sjabloon::Newsletter
  class Buttondown
    include HTTParty

    def initialize
      api_key   = Rails.application.credentials.dig(:buttondown, :api_key)
      @base_uri = "https://api.buttondown.email/v1"
      @auth     = { "Authorization": "Token #{api_key}" }
    end

    def subscribe(options)
      body = {
        "email": options[:email],
      }

      response = HTTParty.post(
        "#{@base_uri}/subscribers",
        headers: @auth,
        body:    body
      )

      response.response
    end
  end
end

