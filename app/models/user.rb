class User < ApplicationRecord
  include Storext.model
  include Sjabloon::Consentable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :masqueradable

  has_person_name

  has_many :employees
  has_many :companies, through: :employees

  validates :name, presence: true
  has_many :sent_invites, class_name: 'Invite', foreign_key: 'sender_id'

  store_attributes :communication_settings do
    newsletter_subscribed Boolean, default: false
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
