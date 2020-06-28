class InviteMailer < ApplicationMailer
  def new_user_invite(invite)
    @token  = invite.token
    @sender = User.find(invite.sender_id)
    @company   = Company.find(invite.company_id)

    mail(to: invite.email, subject: "You are invited to #{Rails.configuration.application_name}")
  end

  def existing_user_invite(invite)
    @sender = User.find(invite.sender_id)
    @company   = Company.find(invite.company_id)

    mail(to: invite.email, subject: "You now have access to #{@company.name} on #{Rails.configuration.application_name}")
  end
end

