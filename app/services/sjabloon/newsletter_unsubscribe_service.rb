module Sjabloon
  class NewsletterUnsubscribeService
    require_relative "./newsletter/mailchimp"

    def initialize(params)
      @params = params
    end

    def self.call(params)
      new(params).send(:perform)
    end

    private

    attr_reader :provider, :params

    def perform
      get_provider
      send("#{provider}_unsubscribe", params)
    end

    def mailchimp_unsubscribe(params)
      Sjabloon::Newsletter::Mailchimp.new.unsubscribe(params)
    end

    def mailerlite_unsubscribe(params)
      Sjabloon::Newsletter::Mailerlite.new.unsubscribe(params)
    end

    def get_provider
      @provider ||= AppConfig.email_marketing["provider"].downcase
    end
  end
end

