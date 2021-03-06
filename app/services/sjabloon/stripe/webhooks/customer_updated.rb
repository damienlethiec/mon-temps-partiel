module Sjabloon
  module Stripe
    module Webhooks
      class CustomerUpdated
        def call(event)
          object = event.data.object
          owner  = AppConfig.billing["payer_class"].constantize.find_by(
            processor:    "stripe",
            processor_id: object.id
          )

          return unless owner.present?

          owner.sync_card_from_stripe
        end
      end
    end
  end
end

