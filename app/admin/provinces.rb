ActiveAdmin.register Province do
  permit_params :name, :code, :gst, :pst, :hst

  filter :name
  filter :code

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :gst
    column :pst
    column :hst
    column :total_tax_rate do |p| "#{(p.total_tax_rate * 100).round(2)}%" end
    actions
  end

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :code
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end
end