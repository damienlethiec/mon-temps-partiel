class Sjabloon::NewsletterUnsubscribeJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    Sjabloon::NewsletterUnsubscribeService.({email: user.email})
  end
end

