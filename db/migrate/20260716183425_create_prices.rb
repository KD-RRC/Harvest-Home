class CreatePrices < ActiveRecord::Migration[8.1]
  def change
    create_table :prices do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :amount
      t.datetime :effective_date

      t.timestamps
    end
  end
end
