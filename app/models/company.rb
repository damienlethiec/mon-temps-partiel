class Company < ApplicationRecord
  include Sjabloon::Stripe::Payer
  include Friendlyable

  has_many :employees
  has_many :users, through: :employees

  validates :name, presence: true

  has_many :invites
end

