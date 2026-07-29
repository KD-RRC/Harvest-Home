# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Store Overview" do
          ul do
            li "Total Products: #{Product.count}"
            li "Active Products: #{Product.where(active: true).count}"
            li "Total Orders: #{Order.count}"
            li "Pending Orders: #{Order.where(status: 'pending').count}"
            li "Total Customers: #{User.count}"
            li "Total Categories: #{Category.count}"
          end
        end
      end
      column do
        panel "Recent Orders" do
          table_for Order.order(created_at: :desc).limit(5) do
            column :id
            column :user do |o| o.user.email end
            column :total_amount do |o| number_to_currency(o.total_amount) end
            column :status
            column :created_at
          end
        end
      end
    end
  end
end