class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :hash_id, null: false

      t.timestamps
    end

    add_index :companies, :hash_id
  end
end

