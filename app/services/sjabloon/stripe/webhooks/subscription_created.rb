module Sjabloon
  module Stripe
    module Webhooks
      class SubscriptionCreated
        def call(event)
          object = event.data.object

          subscription = Sjabloon::Subscription.find_by(
            processor:    "stripe",
            processor_id: object.id
          )

          if subscription.nil?
            owner = AppConfig.billing["payer_class"].constantize.find_by(
              processor:    "stripe",
              processor_id: object.customer
            )

            return if owner.nil?

            subscription = Sjabloon::Subscription.new(owner: owner)
          end

          subscription.quantity       = object.quantity
          subscription.processor_plan = object.plan.id
          subscription.trial_ends_at  = Time.at(object.trial_end) if object.trial_end.present?

          if object.cancel_at_period_end && subscription.on_trial?
            subscription.ends_at = subscription.trial_ends_at

          elsif object.cancel_at_period_end
            subscription.ends_at = Time.at(object.current_period_end)

          else
            subscription.ends_at = nil
          end

          subscription.save!
        end
      end
    end
  end
end

