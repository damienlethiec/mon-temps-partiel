require "httparty"

module Sjabloon::Newsletter
  class Mailerlite
    include HTTParty

    def initialize
      api_key   = Rails.application.credentials.dig(:mailerlite, :api_key)
      @base_uri = "https://api.mailerlite.com/api/v2"
      @auth     = { "X-Mailerlite-Apikey": api_key }
    end

    def subscribe(options)
      options = {
        group_id: AppConfig.email_marketing["default_group_id"],
      }.merge!(options)

      body = {
        "email": options[:email],
        "name":  options[:name],
      }

      response = HTTParty.post(
        "#{@base_uri}/groups//subscribers",
        headers: @auth,
        body:    body
      )

      response.response
    end

    def unsubscribe(options)
      body = {
        "type": "unsubscribed"
      }

      response = HTTParty.put(
        "#{@base_uri}/subscribers/",
        headers: @auth,
        body:    body
      )

      response.response
    end
  end
end

