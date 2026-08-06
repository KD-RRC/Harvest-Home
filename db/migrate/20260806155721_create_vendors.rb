class CreateVendors < ActiveRecord::Migration[8.1]
  def change
    create_table :vendors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :business_name
      t.text :description
      t.boolean :approved

      t.timestamps
    end
  end
end
