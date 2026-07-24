class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_snapshot, presence: true, numericality: { greater_than: 0 }

  def subtotal
    quantity * unit_price_snapshot
  end

  def self.ransackable_attributes(auth_object = nil)
    ["quantity", "unit_price_snapshot", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end
end