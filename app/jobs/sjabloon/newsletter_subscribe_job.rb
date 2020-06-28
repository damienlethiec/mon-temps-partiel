class Sjabloon::NewsletterSubscribeJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    Sjabloon::NewsletterSubscribeService.({email: user.email, first_name: user.first_name})
  end
end

