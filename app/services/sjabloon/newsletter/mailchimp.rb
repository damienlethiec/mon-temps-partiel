require "httparty"

module Sjabloon::Newsletter
  class Mailchimp
    include HTTParty

    def initialize
      api_key   = Rails.application.credentials.dig(:mailchimp, :api_key)
      dc        = api_key.split("-").last
      @base_uri = "https://#{dc}.api.mailchimp.com/3.0/"
      @auth     = { username: "apikey", password: api_key }
    end

    def subscribe(options)
      options = {
        list_id: AppConfig.email_marketing["default_list"],
        status: "subscribed",
        name: "",
        last_name: ""
      }.merge!(options)

      body = {
        "email_address": options[:email],
        "status": options[:status],
        "merge_fields": {
          "FNAME": options[:name],
          "LNAME": options[:last_name]
        }
      }

      response = HTTParty.post("#{@base_uri}/lists/#{options[:list_id]}/members/", basic_auth: @auth, body: body.to_json)
      response.parsed_response
    end

    def unsubscribe(options)
      options = {
        list_id: AppConfig.email_marketing["default_list"],
        status: "unsubscribed",
      }.merge!(options)

      body = {
        "status": options[:status],
      }

      subscriber_hash = Digest::MD5.hexdigest(options[:email].downcase)

      response = HTTParty.patch("#{@base_uri}/lists/#{options[:list_id]}/members/#{subscriber_hash}", basic_auth: @auth, body: body.to_json)
      response.response
    end
  end
end

