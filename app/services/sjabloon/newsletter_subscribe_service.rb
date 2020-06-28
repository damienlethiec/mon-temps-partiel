module Sjabloon
  class NewsletterSubscribeService
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
      send("#{provider}_subscribe", params)
    end

    def mailchimp_subscribe(params)
      Sjabloon::Newsletter::Mailchimp.new.subscribe(params)
    end

    def mailerlite_subscribe(params)
      Sjabloon::Newsletter::Mailerlite.new.subscribe(params)
    end

    def buttondown_subscribe(params)
      Sjabloon::Newsletter::Buttondown.new.subscribe(params)
    end

    def get_provider
      @provider ||= AppConfig.email_marketing["provider"].downcase
    end
  end
end

