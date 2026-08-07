# Represents a customer order with immutable price and tax snapshots
# Status flow: pending -> paid -> shipped -> cancelled

# Order stores immutable snapshots of prices and tax rates at time of purchase.
# unit_price_snapshot on order_items ensures past orders are never affected by price changes.
# tax_rate_snapshot ensures past orders are never affected by tax rate changes.
# stripe_payment_id links this order to the Stripe payment record.
class Order < ApplicationRecord
  
  #Relationships #
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Model Validations #
  validates :status, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :shipping_address, presence: true


  def self.ransackable_associations(auth_object = nil)
    ["user", "province", "order_items"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["status", "total_amount", "tax_amount", "created_at", "updated_at", "stripe_payment_id"]
  end
end