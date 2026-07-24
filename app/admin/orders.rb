ActiveAdmin.register Order do
  permit_params :status

  filter :status
  filter :created_at

  index do
    selectable_column
    id_column
    column :user do |order| order.user.email end
    column :status
    column :total_amount do |order| number_to_currency(order.total_amount) end
    column :tax_amount do |order| number_to_currency(order.tax_amount) end
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :status, as: :select, collection: ['pending', 'paid', 'shipped', 'cancelled']
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user do |order| order.user.email end
      row :status
      row :shipping_address
      row :total_amount do |order| number_to_currency(order.total_amount) end
      row :tax_amount do |order| number_to_currency(order.tax_amount) end
      row :tax_rate_snapshot
      row :created_at
    end
  end
end