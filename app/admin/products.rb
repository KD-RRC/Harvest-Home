ActiveAdmin.register Product do
  permit_params :name, :description, :sku, :stock_quantity, :active, category_ids: []

  filter :name
  filter :sku
  filter :stock_quantity
  filter :active
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :sku
    column :stock_quantity
    column :active
    column :current_price do |product|
      product.current_price&.amount ? number_to_currency(product.current_price.amount) : "No price set"
    end
    column :categories do |product|
      product.categories.map(&:name).join(", ")
    end
    actions
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :sku
      f.input :stock_quantity
      f.input :active
      f.input :categories, as: :check_boxes, collection: Category.all
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :sku
      row :stock_quantity
      row :active
      row :categories do |product|
        product.categories.map(&:name).join(", ")
      end
      row :current_price do |product|
        product.current_price&.amount ? number_to_currency(product.current_price.amount) : "No price set"
      end
      row :created_at
      row :updated_at
    end
  end
end