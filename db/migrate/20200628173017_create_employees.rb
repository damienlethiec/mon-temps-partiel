class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end

