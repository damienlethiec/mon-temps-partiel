class Sjabloon::SubscribersController < ApplicationController
  def create
    Sjabloon::NewsletterSubscribeService.({ email: params[:email] })
  end
end

