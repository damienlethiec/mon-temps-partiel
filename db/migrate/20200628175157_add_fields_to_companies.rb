class AddFieldsToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :processor, :string
    add_column :companies, :processor_id, :string
    add_column :companies, :trial_ends_at, :datetime
    add_column :companies, :card_type, :string
    add_column :companies, :card_last4, :string
    add_column :companies, :card_exp_month, :string
    add_column :companies, :card_exp_year, :string
  end
end

