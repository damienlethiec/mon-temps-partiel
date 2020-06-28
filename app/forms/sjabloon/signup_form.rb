module Sjabloon
  class SignupForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :company_name, :string
    attribute :name, :string
    attribute :email, :string
    attribute :password, :string
    attribute :invite_token, :string
    attribute :subscribe_to_newsletter, :boolean, default: false
    attribute :accepted_terms, :boolean
    attribute :accepted_privacy, :boolean

    validates :company_name, :name, :email, :password, presence: true
    validates :accepted_terms, acceptance: true
    validates :accepted_privacy, acceptance: true

    validate :email_is_unique

    def save!
      ActiveRecord::Base.transaction do
        create_user
        find_or_create_company
        reset_invite
        consent_to_policies
        add_to_newsletter
      end if valid?
    end

    def object
      @user
    end

    private

    def create_user
      @user = User.create!(
        name:     name,
        email:    email,
        password: password,
      )

      @user.update! newsletter_subscribed: subscribe_to_newsletter if newsletter_subscribed_exists?
    end

    def find_or_create_company
      company = if valid_token?
               team_from_invite_token
             else
               Company.create!(name: company_name)
             end

      @user.update! company_id: company.id

      company.employees.create! user: @user
    end

    def reset_invite
      return if invalid_token?

      invite.update!(
        accepted_at: Time.current,
        token: nil
      )
    end

    def add_to_newsletter
      if subscribe_to_newsletter.present? && subscribe_to_newsletter
        Sjabloon::NewsletterSubscribeJob.perform_later @user.id
      end
      true
    end

    def consent_to_policies
      ids = Sjabloon::CurrentMandatoryPolicyIdsQuery.new.resolve

      Sjabloon::SaveConsentsService.new(@user, ids).call
    end

    def newsletter_subscribed_exists?
      User.column_names.include? 'newsletter_subscribed'
    end

    def email_is_unique
      if User.exists? email: email
        errors.add :email, 'has already been taken'
      end
    end

    def company_from_invite_token
      Company.find(invite.company_id)
    end

    def invite
      Invite.find_by(token: invite_token)
    end

    def valid_token?
      return false if !invite_token

      Invite.exists? token: invite_token
    end

    def invalid_token?
      !valid_token?
    end
  end
end

